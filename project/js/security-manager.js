/**
 * Frontend Security Manager for Product Design System
 * Client-side security validation, CSRF protection, and secure communication
 */

class SecurityManager {
    constructor() {
        this.csrfToken = null;
        this.apiBaseUrl = '/AddOns/Partner/project/cfc/';
        this.securityConfig = {
            maxRequestRetries: 3,
            requestTimeout: 30000,
            rateLimitWindow: 60000, // 1 minute
            maxRequestsPerWindow: 100
        };
        this.requestHistory = new Map();
        this.init();
    }

    async init() {
        await this.initCSRFToken();
        this.setupGlobalErrorHandler();
        this.setupSecurityHeaders();
        this.initRateLimiting();
    }

    // CSRF Token Management
    async initCSRFToken() {
        try {
            const response = await this.secureRequest('SecurityValidator.cfc', {
                method: 'generateCSRFToken'
            }, false); // Skip CSRF for token generation

            if (response && response.token) {
                this.csrfToken = response.token;
                this.updateCSRFTokenInForms();
            }
        } catch (error) {
            console.error('CSRF token initialization failed:', error);
            this.showSecurityError('Güvenlik token alınamadı');
        }
    }

    updateCSRFTokenInForms() {
        // Update all forms with CSRF token
        document.querySelectorAll('form').forEach(form => {
            let csrfInput = form.querySelector('input[name="csrf_token"]');
            if (!csrfInput) {
                csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = 'csrf_token';
                form.appendChild(csrfInput);
            }
            csrfInput.value = this.csrfToken;
        });
    }

    // Input Validation
    validateInput(value, type, required = false) {
        const validation = {
            isValid: true,
            sanitizedValue: value,
            errors: []
        };

        // Check required field
        if (required && (!value || value.toString().trim() === '')) {
            validation.isValid = false;
            validation.errors.push('Bu alan zorunludur');
            return validation;
        }

        // Skip validation for empty optional fields
        if (!value || value.toString().trim() === '') {
            return validation;
        }

        // Length check
        if (value.toString().length > 1000) {
            validation.isValid = false;
            validation.errors.push('Girdi çok uzun (maksimum 1000 karakter)');
            return validation;
        }

        // XSS Check
        if (this.containsXSS(value)) {
            validation.isValid = false;
            validation.errors.push('Güvenlik nedeniyle bu girdi kabul edilemiyor');
            return validation;
        }

        // SQL Injection Check
        if (this.containsSQLInjection(value)) {
            validation.isValid = false;
            validation.errors.push('Güvenlik nedeniyle bu girdi kabul edilemiyor');
            return validation;
        }

        // Type-specific validation
        switch (type) {
            case 'number':
                validation = this.validateNumber(value, validation);
                break;
            case 'email':
                validation = this.validateEmail(value, validation);
                break;
            case 'projectId':
                validation = this.validateProjectId(value, validation);
                break;
            case 'productName':
                validation = this.validateProductName(value, validation);
                break;
            default:
                validation = this.validateText(value, validation);
        }

        // Sanitize if valid
        if (validation.isValid) {
            validation.sanitizedValue = this.sanitizeInput(value, type);
        }

        return validation;
    }

    // XSS Detection
    containsXSS(input) {
        const xssPatterns = [
            /<script[^>]*>.*?<\/script>/gi,
            /javascript:/gi,
            /on\w+\s*=/gi,
            /<iframe[^>]*>.*?<\/iframe>/gi,
            /<object[^>]*>.*?<\/object>/gi,
            /<embed[^>]*>.*?<\/embed>/gi,
            /<applet[^>]*>.*?<\/applet>/gi,
            /vbscript:/gi,
            /expression\s*\(/gi
        ];

        return xssPatterns.some(pattern => pattern.test(input.toString()));
    }

    // SQL Injection Detection
    containsSQLInjection(input) {
        const sqlPatterns = [
            /(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE)?|INSERT|MERGE|SELECT|UNION|UPDATE)\b)/gi,
            /('|(--)|;|(\|)|(\/\*)|\*\/)/g,
            /((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))/gi,
            /(\bexec\b|\bEXEC\b)/gi,
            /(\bdrop\b|\bDROP\b)/gi,
            /(\bunion\b|\bUNION\b)/gi
        ];

        return sqlPatterns.some(pattern => pattern.test(input.toString()));
    }

    // Type-specific validations
    validateNumber(value, validation) {
        if (!/^-?\d*\.?\d+$/.test(value.toString())) {
            validation.isValid = false;
            validation.errors.push('Geçerli bir sayı giriniz');
        }
        return validation;
    }

    validateEmail(value, validation) {
        const emailRegex = /^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})$/;
        if (!emailRegex.test(value)) {
            validation.isValid = false;
            validation.errors.push('Geçerli bir email adresi giriniz');
        }
        return validation;
    }

    validateProjectId(value, validation) {
        const projectId = parseInt(value);
        if (isNaN(projectId) || projectId <= 0) {
            validation.isValid = false;
            validation.errors.push('Geçerli bir proje ID giriniz');
        }
        return validation;
    }

    validateProductName(value, validation) {
        const nameRegex = /^[a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s\-_.()]{2,100}$/;
        if (!nameRegex.test(value)) {
            validation.isValid = false;
            validation.errors.push('Ürün adı 2-100 karakter arasında olmalı ve sadece harf, rakam, boşluk ve temel noktalama işaretleri içermelidir');
        }
        return validation;
    }

    validateText(value, validation) {
        // Basic text validation - allow most characters but ensure it's not malicious
        return validation;
    }

    // Input Sanitization
    sanitizeInput(value, type) {
        let sanitized = value.toString().trim();

        switch (type) {
            case 'number':
                sanitized = sanitized.replace(/[^0-9.-]/g, '');
                break;
            case 'alphanumeric':
                sanitized = sanitized.replace(/[^a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s]/g, '');
                break;
            case 'productName':
                sanitized = sanitized.replace(/[^a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s\-_.]/g, '');
                break;
            default:
                // HTML encode dangerous characters
                sanitized = this.htmlEncode(sanitized);
        }

        return sanitized;
    }

    htmlEncode(str) {
        return str
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    // Secure AJAX Requests
    async secureRequest(endpoint, data = {}, includeCSRF = true) {
        try {
            // Rate limiting check
            if (!this.checkRateLimit()) {
                throw new Error('Çok fazla istek gönderildi. Lütfen bekleyiniz.');
            }

            // Prepare request data
            const requestData = { ...data };
            
            if (includeCSRF && this.csrfToken) {
                requestData.csrf_token = this.csrfToken;
            }

            // Add security headers
            const headers = {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest',
                'Cache-Control': 'no-cache'
            };

            // Create request
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), this.securityConfig.requestTimeout);

            const response = await fetch(this.apiBaseUrl + endpoint, {
                method: 'POST',
                headers: headers,
                body: this.buildFormData(requestData),
                signal: controller.signal,
                credentials: 'same-origin' // Include cookies for session
            });

            clearTimeout(timeoutId);

            if (!response.ok) {
                throw new Error(`HTTP Error: ${response.status}`);
            }

            const responseText = await response.text();
            
            // Try to parse as JSON
            try {
                const jsonResponse = JSON.parse(responseText);
                
                // Check for security errors
                if (jsonResponse.error && jsonResponse.code === 'SECURITY_ERROR') {
                    this.handleSecurityError(jsonResponse.error);
                    throw new Error(jsonResponse.error);
                }
                
                return jsonResponse;
            } catch (e) {
                // If not JSON, return as text
                return responseText;
            }

        } catch (error) {
            if (error.name === 'AbortError') {
                throw new Error('İstek zaman aşımına uğradı');
            }
            
            console.error('Secure request failed:', error);
            throw error;
        }
    }

    buildFormData(data) {
        const params = new URLSearchParams();
        for (const [key, value] of Object.entries(data)) {
            params.append(key, value);
        }
        return params;
    }

    // Rate Limiting
    checkRateLimit() {
        const now = Date.now();
        const windowStart = now - this.securityConfig.rateLimitWindow;
        
        // Clean old requests
        for (const [timestamp] of this.requestHistory) {
            if (timestamp < windowStart) {
                this.requestHistory.delete(timestamp);
            }
        }
        
        // Check request count
        if (this.requestHistory.size >= this.securityConfig.maxRequestsPerWindow) {
            return false;
        }
        
        // Add current request
        this.requestHistory.set(now, true);
        return true;
    }

    // Form Security
    secureForm(formElement) {
        if (!formElement) return;

        // Add CSRF token
        let csrfInput = formElement.querySelector('input[name="csrf_token"]');
        if (!csrfInput) {
            csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = 'csrf_token';
            formElement.appendChild(csrfInput);
        }
        csrfInput.value = this.csrfToken;

        // Add validation to form submit
        formElement.addEventListener('submit', (e) => {
            if (!this.validateForm(formElement)) {
                e.preventDefault();
                return false;
            }
        });

        // Add real-time validation to inputs
        const inputs = formElement.querySelectorAll('input, textarea, select');
        inputs.forEach(input => {
            input.addEventListener('blur', () => {
                this.validateFormField(input);
            });
        });
    }

    validateForm(formElement) {
        let isValid = true;
        const inputs = formElement.querySelectorAll('input, textarea, select');
        
        inputs.forEach(input => {
            if (!this.validateFormField(input)) {
                isValid = false;
            }
        });

        return isValid;
    }

    validateFormField(inputElement) {
        const value = inputElement.value;
        const type = inputElement.dataset.validationType || 'text';
        const required = inputElement.hasAttribute('required');
        
        const validation = this.validateInput(value, type, required);
        
        // Remove previous error styling
        inputElement.classList.remove('error', 'is-invalid');
        const existingError = inputElement.parentNode.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }

        if (!validation.isValid) {
            // Add error styling
            inputElement.classList.add('error', 'is-invalid');
            
            // Show error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message text-danger small mt-1';
            errorDiv.textContent = validation.errors[0];
            inputElement.parentNode.appendChild(errorDiv);
            
            return false;
        } else {
            // Update value with sanitized version
            inputElement.value = validation.sanitizedValue;
            inputElement.classList.add('is-valid');
        }

        return true;
    }

    // Security Error Handling
    handleSecurityError(message) {
        console.error('Security Error:', message);
        
        // Show user-friendly error
        this.showSecurityError('Güvenlik nedeniyle işlem gerçekleştirilemedi. Lütfen sayfayı yenileyerek tekrar deneyin.');
        
        // Refresh CSRF token
        this.initCSRFToken();
    }

    showSecurityError(message) {
        if (window.ModernUI) {
            window.ModernUI.createToast(message, 'error', {
                duration: 8000,
                closable: true
            });
        } else {
            alert(message);
        }
    }

    // Global Error Handler
    setupGlobalErrorHandler() {
        window.addEventListener('error', (event) => {
            console.error('Global Error:', event.error);
            
            // Log security-related errors
            if (event.error.message.includes('script') || 
                event.error.message.includes('eval') ||
                event.error.message.includes('injection')) {
                this.logSecurityEvent('Potential XSS attempt', event.error.message);
            }
        });

        // Handle unhandled promise rejections
        window.addEventListener('unhandledrejection', (event) => {
            console.error('Unhandled Promise Rejection:', event.reason);
        });
    }

    // Security Headers
    setupSecurityHeaders() {
        // Add meta tags for security
        const metaTags = [
            { name: 'X-Frame-Options', content: 'DENY' },
            { name: 'X-Content-Type-Options', content: 'nosniff' },
            { name: 'X-XSS-Protection', content: '1; mode=block' }
        ];

        metaTags.forEach(tag => {
            if (!document.querySelector(`meta[name="${tag.name}"]`)) {
                const meta = document.createElement('meta');
                meta.name = tag.name;
                meta.content = tag.content;
                document.head.appendChild(meta);
            }
        });
    }

    // Security Event Logging
    logSecurityEvent(type, details) {
        const logData = {
            type: type,
            details: details,
            timestamp: new Date().toISOString(),
            userAgent: navigator.userAgent,
            url: window.location.href
        };

        // Send to server for logging (fire and forget)
        this.secureRequest('SecurityValidator.cfc', {
            method: 'logSecurityEvent',
            logData: JSON.stringify(logData)
        }, false).catch(error => {
            console.error('Failed to log security event:', error);
        });
    }

    // Content Security Policy validation
    validateCSP() {
        // Check if inline scripts are allowed (they shouldn't be)
        const scripts = document.querySelectorAll('script:not([src])');
        if (scripts.length > 0) {
            console.warn('Inline scripts detected - potential security risk');
        }

        // Monitor eval usage instead of blocking it completely
        const originalEval = window.eval;
        window.eval = function(code) {
            console.warn('eval() usage detected - consider using safer alternatives');
            // Log the eval usage for security monitoring
            if (typeof console !== 'undefined' && console.trace) {
                console.trace('eval() call stack:');
            }
            // Still allow eval but with warning - remove this in production
            return originalEval.call(this, code);
        };
    }

    // Cleanup
    destroy() {
        this.requestHistory.clear();
        this.csrfToken = null;
    }
}

// Initialize Security Manager
const securityManager = new SecurityManager();

// Export for global use
window.SecurityManager = securityManager;

// Auto-secure all forms on page load
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('form').forEach(form => {
        securityManager.secureForm(form);
    });
});

// Secure all dynamically added forms
const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
            if (node.nodeType === Node.ELEMENT_NODE) {
                // Secure new forms
                if (node.tagName === 'FORM') {
                    securityManager.secureForm(node);
                }
                
                // Secure forms within added elements
                const forms = node.querySelectorAll ? node.querySelectorAll('form') : [];
                forms.forEach(form => securityManager.secureForm(form));
            }
        });
    });
});

observer.observe(document.body, {
    childList: true,
    subtree: true
});