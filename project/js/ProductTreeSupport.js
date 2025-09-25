/**
 * ProductTree Supporting Classes
 * Cache, UI, Validator, EventBus, and HTTP Client implementations
 */

'use strict';

/**
 * Enhanced caching system with LRU eviction and TTL
 */
class ProductTreeCache {
    constructor(config) {
        this.config = config;
        this.cache = new Map();
        this.accessTimes = new Map();
        this.maxSize = config.maxCacheSize || 100;
        this.defaultTTL = config.cacheTimeout || 300000; // 5 minutes
        
        // Start cleanup interval
        this.cleanupInterval = setInterval(() => this.cleanup(), 60000); // Every minute
    }

    /**
     * Generate cache key from parameters
     * @param {Object} params - Parameters to generate key from
     * @returns {string} Cache key
     */
    generateKey(params) {
        const keyParts = [
            params.productId,
            params.isVirtual ? 'virtual' : 'real',
            params.tip || 1,
            params.tipo || 1,
            this.config.companyId,
            this.config.priceCatId
        ];
        return keyParts.join('_');
    }

    /**
     * Set cache entry
     * @param {string} key - Cache key
     * @param {*} data - Data to cache
     * @param {number} ttl - Time to live in milliseconds
     */
    async set(key, data, ttl = this.defaultTTL) {
        // Implement LRU eviction
        if (this.cache.size >= this.maxSize) {
            this.evictLRU();
        }

        const entry = {
            data: data,
            timestamp: Date.now(),
            ttl: ttl,
            expires: Date.now() + ttl
        };

        this.cache.set(key, entry);
        this.accessTimes.set(key, Date.now());

        console.log(`Cache set: ${key} (size: ${this.cache.size})`);
    }

    /**
     * Get cache entry
     * @param {string} key - Cache key
     * @returns {*|null} Cached data or null
     */
    async get(key) {
        const entry = this.cache.get(key);
        
        if (!entry) {
            return null;
        }

        // Check if expired
        if (Date.now() > entry.expires) {
            this.cache.delete(key);
            this.accessTimes.delete(key);
            console.log(`Cache expired: ${key}`);
            return null;
        }

        // Update access time
        this.accessTimes.set(key, Date.now());
        
        console.log(`Cache hit: ${key}`);
        return entry.data;
    }

    /**
     * Evict least recently used entry
     * @private
     */
    evictLRU() {
        let oldestKey = null;
        let oldestTime = Date.now();

        for (const [key, time] of this.accessTimes) {
            if (time < oldestTime) {
                oldestTime = time;
                oldestKey = key;
            }
        }

        if (oldestKey) {
            this.cache.delete(oldestKey);
            this.accessTimes.delete(oldestKey);
            console.log(`Cache evicted LRU: ${oldestKey}`);
        }
    }

    /**
     * Cleanup expired entries
     * @private
     */
    cleanup() {
        const now = Date.now();
        const keysToDelete = [];

        for (const [key, entry] of this.cache) {
            if (now > entry.expires) {
                keysToDelete.push(key);
            }
        }

        keysToDelete.forEach(key => {
            this.cache.delete(key);
            this.accessTimes.delete(key);
        });

        if (keysToDelete.length > 0) {
            console.log(`Cache cleanup: removed ${keysToDelete.length} expired entries`);
        }
    }

    /**
     * Clear all cache entries
     */
    clear() {
        this.cache.clear();
        this.accessTimes.clear();
        console.log('Cache cleared');
    }

    /**
     * Update configuration
     * @param {Object} newConfig - New configuration
     */
    updateConfig(newConfig) {
        this.config = { ...this.config, ...newConfig };
    }

    /**
     * Get cache statistics
     * @returns {Object} Cache statistics
     */
    getStats() {
        return {
            size: this.cache.size,
            maxSize: this.maxSize,
            utilization: (this.cache.size / this.maxSize * 100).toFixed(2) + '%'
        };
    }

    /**
     * Destroy cache and cleanup
     */
    destroy() {
        if (this.cleanupInterval) {
            clearInterval(this.cleanupInterval);
        }
        this.clear();
    }
}

/**
 * UI Management class for ProductTree
 */
class ProductTreeUI {
    constructor(manager) {
        this.manager = manager;
        this.elements = {};
        this.loadingStates = new Set();
        this.toasts = [];
        
        this.bindElements();
    }

    /**
     * Initialize UI
     */
    init() {
        this.setupToastContainer();
        this.setupLoadingIndicator();
        this.setupCacheIndicator();
        this.setupTreePlaceholder();
    }

    /**
     * Bind DOM elements
     * @private
     */
    bindElements() {
        this.elements = {
            treeArea: document.getElementById('TreeArea'),
            pnamemain: document.getElementById('pnamemain'),
            vp_id: document.getElementById('vp_id'),
            is_virtual: document.getElementById('is_virtual'),
            pstage: document.getElementById('pstage'),
            maliyet: document.getElementById('maliyet'),
            leftMenu: document.getElementById('leftMenuProject')
        };
    }

    /**
     * Setup toast notification container
     * @private
     */
    setupToastContainer() {
        if (!document.getElementById('toast-container')) {
            const container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                max-width: 400px;
            `;
            document.body.appendChild(container);
        }
    }

    /**
     * Setup global loading indicator
     * @private
     */
    setupLoadingIndicator() {
        if (!document.getElementById('global-loader')) {
            const loader = document.createElement('div');
            loader.id = 'global-loader';
            loader.className = 'global-loader';
            loader.innerHTML = `
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">Yükleniyor...</span>
                </div>
                <div class="loading-text">İşleniyor...</div>
            `;
            document.body.appendChild(loader);
        }
    }

    /**
     * Setup cache indicator
     * @private
     */
    setupCacheIndicator() {
        if (!document.getElementById('cache-indicator')) {
            const indicator = document.createElement('div');
            indicator.id = 'cache-indicator';
            indicator.className = 'cache-indicator';
            indicator.innerHTML = `
                <i class="fa fa-database"></i> 
                <span id="cache-status">Cache Ready</span>
            `;
            document.body.appendChild(indicator);
        }
    }

    /**
     * Setup tree placeholder
     * @private
     */
    setupTreePlaceholder() {
        const treeArea = this.elements.treeArea;
        if (treeArea && !document.getElementById('tree-empty-state')) {
            const placeholder = document.createElement('div');
            placeholder.id = 'tree-empty-state';
            placeholder.className = 'tree-empty-state text-center p-4';
            placeholder.innerHTML = `
                <i class="fa fa-sitemap fa-3x text-muted mb-3"></i>
                <h5 class="text-muted">Ürün Ağacı</h5>
                <p class="text-muted">Bir ürün seçin ve ağaç yapısını görüntüleyin</p>
            `;
            placeholder.style.display = 'block';
            treeArea.appendChild(placeholder);
        }
    }

    /**
     * Show loading state
     * @param {string} loadingId - Loading identifier
     */
    showLoading(loadingId) {
        this.loadingStates.add(loadingId);
        this.updateLoadingUI();
    }

    /**
     * Hide loading state
     * @param {string} loadingId - Loading identifier
     */
    hideLoading(loadingId) {
        this.loadingStates.delete(loadingId);
        this.updateLoadingUI();
    }

    /**
     * Update loading UI based on current states
     * @private
     */
    updateLoadingUI() {
        const hasLoading = this.loadingStates.size > 0;
        const loader = document.getElementById('global-loader');
        
        if (loader) {
            loader.style.display = hasLoading ? 'flex' : 'none';
        }

        // Update buttons
        const buttons = document.querySelectorAll('.btn:not(.btn-always-enabled)');
        buttons.forEach(btn => {
            btn.disabled = hasLoading;
            btn.classList.toggle('btn-loading-disabled', hasLoading);
        });
    }

    /**
     * Show tree loading skeleton
     */
    showTreeSkeleton() {
        const skeleton = document.getElementById('tree-skeleton');
        if (skeleton) {
            skeleton.style.display = 'block';
        }
        
        this.hideTreePlaceholder();
    }

    /**
     * Hide tree loading skeleton
     */
    hideTreeSkeleton() {
        const skeleton = document.getElementById('tree-skeleton');
        if (skeleton) {
            skeleton.style.display = 'none';
        }
    }

    /**
     * Show cache hit indicator
     */
    showCacheHit() {
        const indicator = document.getElementById('cache-indicator');
        const status = document.getElementById('cache-status');
        
        if (indicator && status) {
            indicator.className = 'cache-indicator cache-hit';
            indicator.style.display = 'block';
            status.textContent = 'Cache Hit';
            
            setTimeout(() => {
                indicator.style.display = 'none';
            }, 2000);
        }
    }

    /**
     * Clear tree area
     */
    clearTree() {
        const treeArea = this.elements.treeArea;
        if (treeArea) {
            // Remove all children except skeleton and placeholder
            Array.from(treeArea.children).forEach(child => {
                if (!child.id.includes('skeleton') && !child.id.includes('empty-state')) {
                    child.remove();
                }
            });
        }
        
        this.showTreePlaceholder();
    }

    /**
     * Show tree placeholder
     * @private
     */
    showTreePlaceholder() {
        const placeholder = document.getElementById('tree-empty-state');
        if (placeholder) {
            placeholder.style.display = 'block';
        }
    }

    /**
     * Hide tree placeholder
     * @private
     */
    hideTreePlaceholder() {
        const placeholder = document.getElementById('tree-empty-state');
        if (placeholder) {
            placeholder.style.display = 'none';
        }
    }

    /**
     * Show error notification
     * @param {string} message - Error message
     * @param {string} context - Error context
     */
    showError(message, context = '') {
        this.showToast({
            type: 'error',
            title: 'Hata!',
            message: message,
            context: context,
            duration: 5000
        });
    }

    /**
     * Show success notification
     * @param {string} message - Success message
     */
    showSuccess(message) {
        this.showToast({
            type: 'success',
            title: 'Başarılı!',
            message: message,
            duration: 3000
        });
    }

    /**
     * Show toast notification
     * @param {Object} options - Toast options
     * @private
     */
    showToast(options) {
        const { type, title, message, context, duration = 3000 } = options;
        const container = document.getElementById('toast-container');
        
        if (!container) return;

        const toastId = 'toast_' + Date.now();
        const toast = document.createElement('div');
        toast.id = toastId;
        toast.className = `alert alert-${type === 'error' ? 'danger' : 'success'} alert-dismissible fade show`;
        toast.style.cssText = 'margin-bottom: 10px; animation: slideInRight 0.3s ease-out;';
        
        toast.innerHTML = `
            <strong>${title}</strong> ${message}
            ${context ? `<br><small class="text-muted">[${context}]</small>` : ''}
            <button type="button" class="close" onclick="this.parentElement.remove()">
                <span>&times;</span>
            </button>
        `;

        container.appendChild(toast);
        this.toasts.push(toastId);

        // Auto remove
        setTimeout(() => {
            if (toast.parentElement) {
                toast.remove();
                this.toasts = this.toasts.filter(id => id !== toastId);
            }
        }, duration);
    }

    /**
     * Update product information in UI
     * @param {Object} productInfo - Product information
     */
    updateProductInfo(productInfo) {
        const { productId, isVirtual, name, stage } = productInfo;
        
        if (this.elements.pnamemain) this.elements.pnamemain.value = name || '';
        if (this.elements.vp_id) this.elements.vp_id.value = productId || '';
        if (this.elements.is_virtual) this.elements.is_virtual.value = isVirtual ? '1' : '0';
        if (this.elements.pstage && stage) this.elements.pstage.value = stage;
    }

    /**
     * Update cost display
     * @param {number} cost - Total cost
     */
    updateCost(cost) {
        if (this.elements.maliyet) {
            this.elements.maliyet.value = this.formatCurrency(cost);
        }
    }

    /**
     * Format currency value
     * @param {number} value - Numeric value
     * @returns {string} Formatted currency
     * @private
     */
    formatCurrency(value) {
        if (typeof window.tlformat === 'function') {
            return window.tlformat(value);
        }
        
        return new Intl.NumberFormat('tr-TR', {
            style: 'currency',
            currency: 'TRY'
        }).format(value);
    }

    /**
     * Destroy UI and cleanup
     */
    destroy() {
        // Remove toasts
        this.toasts.forEach(toastId => {
            const toast = document.getElementById(toastId);
            if (toast) toast.remove();
        });
        
        // Clear loading states
        this.loadingStates.clear();
        this.updateLoadingUI();
    }
}

/**
 * Validation class for ProductTree operations
 */
class ProductTreeValidator {
    /**
     * Validate load parameters
     * @param {Object} params - Parameters to validate
     * @returns {Object} Validation result
     */
    validateLoadParams(params) {
        const errors = [];
        
        if (!params.productId || typeof params.productId !== 'number') {
            errors.push('Product ID must be a valid number');
        }
        
        if (typeof params.isVirtual !== 'boolean') {
            errors.push('isVirtual must be a boolean');
        }
        
        if (params.tip !== undefined && ![1, 2, 3, 4, 5].includes(params.tip)) {
            errors.push('tip must be 1, 2, 3, 4, or 5');
        }
        
        return {
            isValid: errors.length === 0,
            errors: errors
        };
    }

    /**
     * Validate tree data structure
     * @param {*} treeData - Tree data to validate
     * @returns {Object} Validation result
     */
    validateTreeData(treeData) {
        const errors = [];
        
        if (!treeData) {
            errors.push('Tree data is required');
            return { isValid: false, errors };
        }
        
        if (!Array.isArray(treeData) && typeof treeData !== 'object') {
            errors.push('Tree data must be an array or object');
        }
        
        // Additional structure validation could go here
        
        return {
            isValid: errors.length === 0,
            errors: errors
        };
    }

    /**
     * Validate save data
     * @param {Object} saveData - Data to save
     * @returns {Object} Validation result
     */
    validateSaveData(saveData) {
        const errors = [];
        
        if (!saveData) {
            errors.push('Save data is required');
            return { isValid: false, errors };
        }
        
        if (!saveData.PRODUCT_TREE || !Array.isArray(saveData.PRODUCT_TREE)) {
            errors.push('PRODUCT_TREE must be an array');
        }
        
        if (!saveData.PROJECT_ID) {
            errors.push('PROJECT_ID is required');
        }
        
        return {
            isValid: errors.length === 0,
            errors: errors
        };
    }
}

/**
 * Event bus for ProductTree system communication
 */
class ProductTreeEventBus {
    constructor() {
        this.events = new Map();
    }

    /**
     * Subscribe to event
     * @param {string} event - Event name
     * @param {Function} callback - Event callback
     */
    on(event, callback) {
        if (!this.events.has(event)) {
            this.events.set(event, []);
        }
        this.events.get(event).push(callback);
    }

    /**
     * Unsubscribe from event
     * @param {string} event - Event name
     * @param {Function} callback - Event callback to remove
     */
    off(event, callback) {
        if (!this.events.has(event)) return;
        
        const callbacks = this.events.get(event);
        const index = callbacks.indexOf(callback);
        if (index > -1) {
            callbacks.splice(index, 1);
        }
    }

    /**
     * Emit event
     * @param {string} event - Event name
     * @param {*} data - Event data
     */
    emit(event, data) {
        if (!this.events.has(event)) return;
        
        this.events.get(event).forEach(callback => {
            try {
                callback(data);
            } catch (error) {
                console.error(`Event callback error for '${event}':`, error);
            }
        });
    }

    /**
     * Remove all listeners
     */
    removeAllListeners() {
        this.events.clear();
    }
}

/**
 * HTTP client for API requests
 */
class ProductTreeHttpClient {
    constructor() {
        this.defaultTimeout = 30000;
    }

    /**
     * Make HTTP request
     * @param {Object} options - Request options
     * @returns {Promise<*>} Request response
     */
    async request(options) {
        const { url, method = 'GET', params = {}, data = null, timeout = this.defaultTimeout } = options;
        
        return new Promise((resolve, reject) => {
            const ajaxOptions = {
                url: url,
                method: method,
                timeout: timeout,
                success: (response) => {
                    try {
                        // Try to parse JSON if response is string
                        const parsedResponse = typeof response === 'string' 
                            ? JSON.parse(response) 
                            : response;
                        resolve(parsedResponse);
                    } catch (error) {
                        console.warn('Response parsing failed, returning raw response:', error);
                        resolve(response);
                    }
                },
                error: (xhr, status, error) => {
                    const apiError = new ApiError(
                        error || 'Request failed',
                        xhr.status,
                        xhr.responseText
                    );
                    reject(apiError);
                }
            };

            // Add parameters based on method
            if (method.toUpperCase() === 'GET' && Object.keys(params).length > 0) {
                const urlParams = new URLSearchParams(params).toString();
                ajaxOptions.url += (url.includes('?') ? '&' : '?') + urlParams;
            } else if (data || Object.keys(params).length > 0) {
                ajaxOptions.data = data || params;
            }

            $.ajax(ajaxOptions);
        });
    }
}

// Assign to ProductTreeManager prototype for dependency injection
if (typeof window !== 'undefined') {
    window.ProductTreeManager.prototype.cache = null;
    window.ProductTreeManager.prototype.ui = null;
    window.ProductTreeManager.prototype.validator = null;
    window.ProductTreeManager.prototype.eventBus = null;
    window.ProductTreeManager.prototype.httpClient = new ProductTreeHttpClient();

    // Export classes
    window.ProductTreeCache = ProductTreeCache;
    window.ProductTreeUI = ProductTreeUI;
    window.ProductTreeValidator = ProductTreeValidator;
    window.ProductTreeEventBus = ProductTreeEventBus;
    window.ProductTreeHttpClient = ProductTreeHttpClient;
}

console.log('ProductTree supporting classes loaded successfully');