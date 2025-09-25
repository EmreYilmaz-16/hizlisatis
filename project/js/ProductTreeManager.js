/**
 * Modern ProductTree Management System
 * ES6+ Class-based Architecture with TypeScript-like documentation
 * Created: September 2025
 */

'use strict';

/**
 * @typedef {Object} ProductTreeNode
 * @property {number} PRODUCT_ID - Unique product identifier
 * @property {string} PRODUCT_NAME - Product name
 * @property {number} AMOUNT - Product amount
 * @property {number} STOCK_ID - Stock identifier
 * @property {string} DISPLAYNAME - Display name
 * @property {string} PBS_ROW_ID - PBS row identifier
 * @property {boolean} IS_VIRTUAL - Virtual product flag
 * @property {number} PRICE - Product price
 * @property {number} STANDART_PRICE - Standard price
 * @property {string} MONEY - Currency
 * @property {number} DISCOUNT - Discount percentage
 * @property {string} PRODUCT_TREE_ID - Tree identifier
 * @property {string} QUESTION_ID - Question identifier
 * @property {string} QUESTION_NAME - Question name
 * @property {ProductTreeNode[]|string} AGAC - Child nodes or empty string
 */

/**
 * @typedef {Object} TreeConfig
 * @property {number} companyId - Company ID
 * @property {number} priceCatId - Price category ID  
 * @property {string} dsn3 - Database source name
 * @property {number} projectId - Project ID
 * @property {boolean} enableCache - Enable caching
 * @property {number} cacheTimeout - Cache timeout in milliseconds
 */

/**
 * ProductTree Management Class
 * Handles all product tree operations with modern patterns
 */
class ProductTreeManager {
    /**
     * @param {TreeConfig} config - Configuration object
     */
    constructor(config = {}) {
        this.config = {
            companyId: config.companyId || window._compId,
            priceCatId: config.priceCatId || window._priceCatId,
            dsn3: config.dsn3 || 'workcube_metosan_1',
            projectId: config.projectId || window.project_id || 2563,
            enableCache: config.enableCache !== false,
            cacheTimeout: config.cacheTimeout || 300000, // 5 minutes
            maxRetries: config.maxRetries || 3,
            retryDelay: config.retryDelay || 1000
        };

        // Initialize subsystems
        this.cache = new ProductTreeCache(this.config);
        this.ui = new ProductTreeUI(this);
        this.validator = new ProductTreeValidator();
        this.eventBus = new ProductTreeEventBus();
        this.httpClient = new ProductTreeHttpClient();
        
        // State management
        this.state = {
            currentTree: null,
            selectedProduct: null,
            isLoading: false,
            errors: [],
            lastUpdate: null
        };

        // Bind methods
        this.loadTree = this.loadTree.bind(this);
        this.saveTree = this.saveTree.bind(this);
        this.deleteProduct = this.deleteProduct.bind(this);
        
        this.init();
    }

    /**
     * Initialize the ProductTree system
     * @private
     */
    init() {
        try {
            this.setupGlobalErrorHandling();
            this.setupEventListeners();
            this.ui.init();
            
            console.log('ProductTreeManager initialized successfully', this.config);
            this.eventBus.emit('system:ready', { manager: this });
        } catch (error) {
            console.error('ProductTreeManager initialization failed:', error);
            this.handleError(error, 'initialization');
        }
    }

    /**
     * Setup global error handling
     * @private
     */
    setupGlobalErrorHandling() {
        window.addEventListener('unhandledrejection', (event) => {
            console.error('Unhandled Promise Rejection:', event.reason);
            this.handleError(event.reason, 'unhandled_promise');
        });

        window.addEventListener('error', (event) => {
            console.error('Global Error:', event.error);
            this.handleError(event.error, 'global_error');
        });
    }

    /**
     * Setup event listeners
     * @private
     */
    setupEventListeners() {
        // Listen for configuration changes
        this.eventBus.on('config:change', (newConfig) => {
            this.updateConfig(newConfig);
        });

        // Listen for UI events
        this.eventBus.on('ui:product_selected', (data) => {
            this.handleProductSelection(data);
        });

        this.eventBus.on('ui:tree_modified', (data) => {
            this.handleTreeModification(data);
        });
    }

    /**
     * Load product tree with modern async/await pattern
     * @param {Object} params - Load parameters
     * @param {number} params.productId - Product ID
     * @param {boolean} params.isVirtual - Is virtual product
     * @param {number} params.tip - Load type
     * @param {number} params.tipo - Load tipo
     * @returns {Promise<ProductTreeNode[]>}
     */
    async loadTree(params) {
        const { productId, isVirtual, tip = 1, tipo = 1 } = params;
        
        // Validate input parameters
        const validation = this.validator.validateLoadParams(params);
        if (!validation.isValid) {
            throw new ValidationError('Invalid parameters', validation.errors);
        }

        const loadId = `load_${productId}_${tip}_${Date.now()}`;
        
        try {
            this.setState({ isLoading: true });
            this.ui.showLoading(loadId);
            
            console.log(`Loading tree for product ${productId}, virtual: ${isVirtual}, tip: ${tip}`);
            
            // Check cache first
            const cacheKey = this.cache.generateKey({ productId, isVirtual, tip, tipo });
            
            if (this.config.enableCache) {
                const cached = await this.cache.get(cacheKey);
                if (cached) {
                    console.log('Cache hit for product tree:', cacheKey);
                    this.ui.showCacheHit();
                    return this.processTreeData(cached, params);
                }
            }

            // Fetch product info if needed
            const productInfo = await this.fetchProductInfo(productId, isVirtual);
            
            // Build API request
            const apiParams = this.buildApiParams(productId, isVirtual, productInfo.stockId, tipo);
            
            // Make API call with retry logic
            const treeData = await this.makeApiCall(apiParams, cacheKey);
            
            // Process and validate response
            const processedData = await this.processTreeData(treeData, params);
            
            // Update state
            this.setState({ 
                currentTree: processedData,
                selectedProduct: { productId, isVirtual, name: productInfo.name },
                lastUpdate: new Date()
            });

            // Emit success event
            this.eventBus.emit('tree:loaded', { data: processedData, params });
            
            return processedData;

        } catch (error) {
            this.handleError(error, 'loadTree', { productId, isVirtual, tip });
            throw error;
        } finally {
            this.setState({ isLoading: false });
            this.ui.hideLoading(loadId);
        }
    }

    /**
     * Fetch product information
     * @param {number} productId - Product ID
     * @param {boolean} isVirtual - Is virtual product
     * @returns {Promise<{name: string, stockId: number}>}
     * @private
     */
    async fetchProductInfo(productId, isVirtual) {
        try {
            const query = isVirtual 
                ? `SELECT PRODUCT_NAME FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=${productId}`
                : `SELECT PRODUCT_NAME, STOCK_ID FROM STOCKS WHERE PRODUCT_ID=${productId}`;
            
            const result = await this.executeQuery(query);
            
            return {
                name: result.PRODUCT_NAME[0],
                stockId: isVirtual ? 0 : result.STOCK_ID[0]
            };
        } catch (error) {
            throw new Error(`Failed to fetch product info: ${error.message}`);
        }
    }

    /**
     * Execute database query (wrapper for wrk_query)
     * @param {string} query - SQL query
     * @returns {Promise<Object>}
     * @private
     */
    async executeQuery(query) {
        return new Promise((resolve, reject) => {
            try {
                const result = window.wrk_query(query, "DSN3");
                resolve(result);
            } catch (error) {
                reject(error);
            }
        });
    }

    /**
     * Build API parameters for tree request
     * @param {number} productId - Product ID
     * @param {boolean} isVirtual - Is virtual product
     * @param {number} stockId - Stock ID
     * @param {number} tipo - Tipo parameter
     * @returns {Object} API parameters
     * @private
     */
    buildApiParams(productId, isVirtual, stockId, tipo) {
        const params = {
            method: 'getTree',
            product_id: productId,
            isVirtual: isVirtual ? 1 : 0,
            ddsn3: this.config.dsn3,
            company_id: this.config.companyId,
            price_catid: this.config.priceCatId,
            tipo: tipo
        };

        if (!isVirtual && stockId) {
            params.stock_id = stockId;
        }

        return params;
    }

    /**
     * Make API call with retry logic
     * @param {Object} params - API parameters
     * @param {string} cacheKey - Cache key for storing result
     * @returns {Promise<Object>} API response
     * @private
     */
    async makeApiCall(params, cacheKey) {
        const url = '/AddOns/Partner/project/cfc/product_design.cfc';
        let lastError;

        for (let attempt = 1; attempt <= this.config.maxRetries; attempt++) {
            try {
                console.log(`API call attempt ${attempt}/${this.config.maxRetries}:`, url);
                
                const response = await this.httpClient.request({
                    url,
                    method: 'GET',
                    params,
                    timeout: 30000
                });

                // Cache successful response
                if (this.config.enableCache && cacheKey) {
                    await this.cache.set(cacheKey, response);
                }

                return response;
                
            } catch (error) {
                lastError = error;
                console.warn(`API call attempt ${attempt} failed:`, error.message);
                
                if (attempt < this.config.maxRetries) {
                    await this.delay(this.config.retryDelay * attempt);
                }
            }
        }

        throw new Error(`API call failed after ${this.config.maxRetries} attempts: ${lastError.message}`);
    }

    /**
     * Process tree data after loading
     * @param {Object} treeData - Raw tree data from API
     * @param {Object} params - Original load parameters
     * @returns {Promise<ProductTreeNode[]>}
     * @private
     */
    async processTreeData(treeData, params) {
        try {
            // Validate tree data structure
            const validation = this.validator.validateTreeData(treeData);
            if (!validation.isValid) {
                throw new ValidationError('Invalid tree data structure', validation.errors);
            }

            // Process based on tip
            switch (params.tip) {
                case 1:
                    await this.renderMainTree(treeData);
                    break;
                case 2:
                    await this.renderSubTree(treeData, params.li);
                    break;
                case 3:
                case 4:
                case 5:
                    await this.renderSpecialTree(treeData, params.tip);
                    break;
                default:
                    console.warn('Unknown tip value:', params.tip);
            }

            // Store global reference for compatibility
            window.o = treeData;

            return treeData;

        } catch (error) {
            throw new Error(`Failed to process tree data: ${error.message}`);
        }
    }

    /**
     * Render main tree (tip = 1)
     * @param {Object} treeData - Tree data to render
     * @private
     */
    async renderMainTree(treeData) {
        try {
            // Clear existing tree
            const treeArea = document.getElementById('TreeArea');
            if (!treeArea) {
                throw new Error('TreeArea element not found');
            }

            this.ui.clearTree();
            this.ui.showTreeSkeleton();

            // Build tree structure
            if (typeof window.AgaciYaz === 'function') {
                window.AgaciYaz(treeData, 0, "0", 1);
            } else {
                await this.buildTreeManually(treeData);
            }

            // Append to DOM
            if (window.ulx) {
                treeArea.appendChild(window.ulx);
            }

            // Apply tree enhancements
            await this.applyTreeEnhancements();

            this.ui.hideTreeSkeleton();

        } catch (error) {
            this.ui.hideTreeSkeleton();
            throw error;
        }
    }

    /**
     * Apply tree enhancements (sorting, virtual elements, cost calculation)
     * @private
     */
    async applyTreeEnhancements() {
        try {
            // Apply sortable functionality
            if (typeof window.sortableYap === 'function') {
                window.sortableYap();
            }

            // Position virtual elements
            if (typeof window.virtuallariYerlestir === 'function') {
                window.virtuallariYerlestir();
            }

            // Add tree interaction handlers
            if (typeof window.agacGosterEkle === 'function') {
                window.agacGosterEkle();
            }

            // Calculate costs
            await this.calculateCosts();

            // Validate tree integrity
            if (this.state.selectedProduct) {
                if (typeof window.GercekKontrol === 'function') {
                    window.GercekKontrol(this.state.selectedProduct.productId);
                }
            }

        } catch (error) {
            console.warn('Tree enhancement failed:', error);
            // Don't throw - enhancements are not critical
        }
    }

    /**
     * Calculate tree costs
     * @private
     */
    async calculateCosts() {
        try {
            if (typeof window.MaliyetHesapla2 === 'function') {
                window.MaliyetHesapla2();
            }

            this.eventBus.emit('costs:calculated', {
                tree: this.state.currentTree,
                timestamp: new Date()
            });

        } catch (error) {
            console.warn('Cost calculation failed:', error);
        }
    }

    /**
     * Save tree changes
     * @param {Object} treeData - Tree data to save
     * @returns {Promise<Object>} Save result
     */
    async saveTree(treeData = null) {
        const dataToSave = treeData || this.state.currentTree;
        
        if (!dataToSave) {
            throw new Error('No tree data to save');
        }

        try {
            this.setState({ isLoading: true });
            
            const validation = this.validator.validateSaveData(dataToSave);
            if (!validation.isValid) {
                throw new ValidationError('Invalid save data', validation.errors);
            }

            const result = await this.httpClient.request({
                url: '/AddOns/Partner/project/cfc/product_design.cfc',
                method: 'POST',
                params: {
                    method: 'SaveTreePrices',
                    FORM_DATA: JSON.stringify(dataToSave)
                }
            });

            // Clear cache after successful save
            this.cache.clear();

            this.eventBus.emit('tree:saved', { result, data: dataToSave });
            
            return result;

        } catch (error) {
            this.handleError(error, 'saveTree');
            throw error;
        } finally {
            this.setState({ isLoading: false });
        }
    }

    /**
     * Delete a product from tree
     * @param {number} productId - Product ID to delete
     * @returns {Promise<boolean>}
     */
    async deleteProduct(productId) {
        if (!productId) {
            throw new Error('Product ID is required');
        }

        try {
            const result = await this.httpClient.request({
                url: '/AddOns/Partner/project/cfc/product_design.cfc',
                method: 'POST',
                params: {
                    method: 'DELVP',
                    vp_id: productId,
                    ddsn3: this.config.dsn3
                }
            });

            // Clear cache
            this.cache.clear();

            // Reload tree if this was the selected product
            if (this.state.selectedProduct?.productId === productId) {
                this.setState({ selectedProduct: null, currentTree: null });
                this.ui.clearTree();
            }

            this.eventBus.emit('product:deleted', { productId, result });
            
            return true;

        } catch (error) {
            this.handleError(error, 'deleteProduct', { productId });
            throw error;
        }
    }

    /**
     * Update manager configuration
     * @param {Partial<TreeConfig>} newConfig - New configuration
     */
    updateConfig(newConfig) {
        this.config = { ...this.config, ...newConfig };
        
        // Update subsystems
        this.cache.updateConfig(this.config);
        
        console.log('Configuration updated:', this.config);
        this.eventBus.emit('config:updated', this.config);
    }

    /**
     * Update manager state
     * @param {Object} newState - New state properties
     * @private
     */
    setState(newState) {
        const oldState = { ...this.state };
        this.state = { ...this.state, ...newState };
        
        this.eventBus.emit('state:changed', { oldState, newState: this.state });
    }

    /**
     * Handle errors with context
     * @param {Error} error - Error object
     * @param {string} context - Error context
     * @param {Object} metadata - Additional error metadata
     * @private
     */
    handleError(error, context, metadata = {}) {
        const errorInfo = {
            error,
            context,
            metadata,
            timestamp: new Date(),
            state: this.state
        };

        this.state.errors.push(errorInfo);
        
        console.error(`ProductTreeManager Error [${context}]:`, errorInfo);
        
        this.eventBus.emit('error:occurred', errorInfo);
        this.ui.showError(error.message, context);
    }

    /**
     * Utility: Delay execution
     * @param {number} ms - Milliseconds to delay
     * @returns {Promise<void>}
     * @private
     */
    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    /**
     * Get current state (read-only)
     * @returns {Object} Current state
     */
    getState() {
        return { ...this.state };
    }

    /**
     * Get configuration (read-only)
     * @returns {TreeConfig} Current configuration
     */
    getConfig() {
        return { ...this.config };
    }

    /**
     * Destroy the manager and cleanup resources
     */
    destroy() {
        try {
            this.eventBus.removeAllListeners();
            this.cache.clear();
            this.ui.destroy();
            
            // Clear global references
            if (window.productTreeManager === this) {
                window.productTreeManager = null;
            }
            
            console.log('ProductTreeManager destroyed');
        } catch (error) {
            console.error('Error during ProductTreeManager destruction:', error);
        }
    }
}

// Custom error classes
class ValidationError extends Error {
    constructor(message, errors = []) {
        super(message);
        this.name = 'ValidationError';
        this.errors = errors;
    }
}

class ApiError extends Error {
    constructor(message, status, response) {
        super(message);
        this.name = 'ApiError';
        this.status = status;
        this.response = response;
    }
}

// Export for global use
if (typeof window !== 'undefined') {
    window.ProductTreeManager = ProductTreeManager;
    window.ValidationError = ValidationError;
    window.ApiError = ApiError;
}

console.log('ProductTreeManager class loaded successfully');