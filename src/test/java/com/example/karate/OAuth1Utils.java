package com.example.karate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Utility class for OAuth 1.0 authentication with RSA-SHA1 signature method
 * Supports Mastercard API Gateway OAuth 1.0 requirements
 */
public class OAuth1Utils {

    private static final String OAUTH_VERSION = "1.0";
    private static final String SIGNATURE_METHOD = "RSA-SHA1";
    private static final String RSA_SHA1_ALGORITHM = "SHA1withRSA";

    /**
     * Generate OAuth 1.0 Authorization header with RSA-SHA1 signature
     * 
     * @param method HTTP method (GET, POST, etc.)
     * @param url Full URL including query parameters
     * @param consumerKey OAuth consumer key
     * @param privateKey Private key in PKCS#8 format (base64 encoded or PEM)
     * @return Authorization header value
     */
    public static String generateOAuth1Header(String method, String url, String consumerKey, String privateKey) {
        try {
            // Parse URL to separate base URL and query parameters
            String baseUrl = url.split("\\?")[0];
            String queryString = url.contains("?") ? url.split("\\?", 2)[1] : "";
            
            // Parse query parameters
            Map<String, String> queryParams = parseQueryString(queryString);
            
            // OAuth parameters
            String timestamp = String.valueOf(System.currentTimeMillis() / 1000);
            String nonce = generateNonce();
            
            Map<String, String> oauthParams = new LinkedHashMap<>();
            oauthParams.put("oauth_consumer_key", consumerKey);
            oauthParams.put("oauth_nonce", nonce);
            oauthParams.put("oauth_signature_method", SIGNATURE_METHOD);
            oauthParams.put("oauth_timestamp", timestamp);
            oauthParams.put("oauth_version", OAUTH_VERSION);
            
            // Combine all parameters for signature base string
            Map<String, String> allParams = new LinkedHashMap<>();
            allParams.putAll(oauthParams);
            allParams.putAll(queryParams);
            
            // Create signature base string
            String signatureBaseString = createSignatureBaseString(method, baseUrl, allParams);
            
            // Generate signature
            String signature = generateRSASignature(signatureBaseString, privateKey);
            
            // Build Authorization header
            oauthParams.put("oauth_signature", signature);
            
            String authHeader = "OAuth " + oauthParams.entrySet().stream()
                    .map(entry -> encode(entry.getKey()) + "=\"" + encode(entry.getValue()) + "\"")
                    .collect(Collectors.joining(", "));
            
            return authHeader;
            
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate OAuth 1.0 header: " + e.getMessage(), e);
        }
    }

    /**
     * Create signature base string according to OAuth 1.0 spec
     */
    private static String createSignatureBaseString(String method, String url, Map<String, String> params) {
        // Normalize URL (remove default ports, etc.)
        String normalizedUrl = normalizeUrl(url);
        
        // Normalize parameters
        String normalizedParams = normalizeParameters(params);
        
        return method.toUpperCase() + "&" + encode(normalizedUrl) + "&" + encode(normalizedParams);
    }

    /**
     * Normalize URL according to OAuth 1.0 spec
     */
    private static String normalizeUrl(String url) {
        try {
            java.net.URL urlObj = new java.net.URL(url);
            String scheme = urlObj.getProtocol().toLowerCase();
            String host = urlObj.getHost().toLowerCase();
            int port = urlObj.getPort();
            String path = urlObj.getPath();
            
            // Remove default ports
            if (port == -1 || 
                (scheme.equals("http") && port == 80) || 
                (scheme.equals("https") && port == 443)) {
                return scheme + "://" + host + path;
            }
            return scheme + "://" + host + ":" + port + path;
        } catch (Exception e) {
            return url;
        }
    }

    /**
     * Normalize parameters according to OAuth 1.0 spec
     */
    private static String normalizeParameters(Map<String, String> params) {
        return params.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(entry -> encode(entry.getKey()) + "=" + encode(entry.getValue()))
                .collect(Collectors.joining("&"));
    }

    /**
     * Generate RSA-SHA1 signature
     */
    private static String generateRSASignature(String data, String privateKeyPem) throws Exception {
        try {
            // Remove PEM headers/footers if present
            String keyContent = privateKeyPem
                    .replace("-----BEGIN PRIVATE KEY-----", "")
                    .replace("-----END PRIVATE KEY-----", "")
                    .replace("-----BEGIN RSA PRIVATE KEY-----", "")
                    .replace("-----END RSA PRIVATE KEY-----", "")
                    .replaceAll("\\s", "");
            
            // Decode base64
            byte[] keyBytes = Base64.getDecoder().decode(keyContent);
            
            // Create PKCS8EncodedKeySpec
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(keyBytes);
            
            // Get KeyFactory
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PrivateKey privateKey = keyFactory.generatePrivate(keySpec);
            
            // Sign the data
            Signature signature = Signature.getInstance(RSA_SHA1_ALGORITHM);
            signature.initSign(privateKey);
            signature.update(data.getBytes(StandardCharsets.UTF_8));
            byte[] signatureBytes = signature.sign();
            
            // Encode signature
            return Base64.getEncoder().encodeToString(signatureBytes);
            
        } catch (Exception e) {
            throw new Exception("Failed to generate RSA signature: " + e.getMessage(), e);
        }
    }

    /**
     * Parse query string into parameter map
     */
    private static Map<String, String> parseQueryString(String queryString) {
        Map<String, String> params = new LinkedHashMap<>();
        if (queryString == null || queryString.isEmpty()) {
            return params;
        }
        
        String[] pairs = queryString.split("&");
        for (String pair : pairs) {
            if (pair.contains("=")) {
                String[] keyValue = pair.split("=", 2);
                String key = decode(keyValue[0]);
                String value = keyValue.length > 1 ? decode(keyValue[1]) : "";
                params.put(key, value);
            }
        }
        return params;
    }

    /**
     * Generate random nonce
     */
    private static String generateNonce() {
        return UUID.randomUUID().toString().replace("-", "") + 
               String.valueOf(System.currentTimeMillis());
    }

    /**
     * URL encode according to RFC 3986
     */
    private static String encode(String value) {
        if (value == null) {
            return "";
        }
        try {
            return URLEncoder.encode(value, StandardCharsets.UTF_8.toString())
                    .replace("+", "%20")
                    .replace("*", "%2A")
                    .replace("%7E", "~");
        } catch (Exception e) {
            return value;
        }
    }

    /**
     * URL decode
     */
    private static String decode(String value) {
        if (value == null) {
            return "";
        }
        try {
            return java.net.URLDecoder.decode(value, StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            return value;
        }
    }
}

