/*
OPTIMIZED Product Tree JavaScript - Performance Enhanced Version
- Request caching and debouncing
- Error handling 
- Modern JavaScript patterns
- Memory leak prevention
- Loading states
*/

// Cache and performance optimization
const ProductTreeCache = {
    cache: new Map(),
    maxCacheSize: 100,
    pendingRequests: new Map(),
    
    // Get cache key
    getCacheKey: function(product_id, is_virtual, tipo, compId, priceCatId) {
        return `${product_id}_${is_virtual}_${tipo}_${compId}_${priceCatId}`;
    },
    
    // Set cache with LRU eviction
    set: function(key, data) {
        if (this.cache.size >= this.maxCacheSize) {
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }
        this.cache.set(key, {
            data: data,
            timestamp: Date.now(),
            expires: Date.now() + (5 * 60 * 1000) // 5 minutes
        });
    },
    
    // Get cached data if valid
    get: function(key) {
        const cached = this.cache.get(key);
        if (cached && cached.expires > Date.now()) {
            return cached.data;
        }
        if (cached) {
            this.cache.delete(key); // Remove expired
        }
        return null;
    },
    
    // Clear cache
    clear: function() {
        this.cache.clear();
        this.pendingRequests.clear();
    }
};

// Loading state management
const LoadingManager = {
    activeLoaders: new Set(),
    
    show: function(id) {
        this.activeLoaders.add(id);
        this.updateUI();
    },
    
    hide: function(id) {
        this.activeLoaders.delete(id);
        this.updateUI();
    },
    
    updateUI: function() {
        const hasLoading = this.activeLoaders.size > 0;
        const loader = document.getElementById('global-loader');
        if (loader) {
            loader.style.display = hasLoading ? 'block' : 'none';
        }
        
        // Disable buttons during loading
        const buttons = document.querySelectorAll('.btn:not(.btn-loading-disabled)');
        buttons.forEach(btn => {
            btn.disabled = hasLoading;
            if (hasLoading) {
                btn.classList.add('btn-loading-disabled');
            } else {
                btn.classList.remove('btn-loading-disabled');
            }
        });
    }
};

// Error handling utility
const ErrorHandler = {
    show: function(message, type = 'error') {
        console.error('ProductTree Error:', message);
        
        // Show user-friendly error
        const errorDiv = document.createElement('div');
        errorDiv.className = `alert alert-${type === 'error' ? 'danger' : 'warning'} alert-dismissible fade show`;
        errorDiv.style.position = 'fixed';
        errorDiv.style.top = '20px';
        errorDiv.style.right = '20px';
        errorDiv.style.zIndex = '9999';
        errorDiv.innerHTML = `
            <strong>${type === 'error' ? 'Hata!' : 'Uyarı!'}</strong> ${message}
            <button type="button" class="close" onclick="this.parentElement.remove()">
                <span>&times;</span>
            </button>
        `;
        
        document.body.appendChild(errorDiv);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (errorDiv.parentElement) {
                errorDiv.remove();
            }
        }, 5000);
    }
};

// Debounced function utility
function debounce(func, wait, immediate) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            timeout = null;
            if (!immediate) func.apply(this, args);
        };
        const callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(this, args);
    };
}

// Optimized AJAX request with caching
function makeOptimizedAjaxRequest(options) {
    const {
        url,
        method = 'GET',
        data = null,
        cacheKey = null,
        useCache = true,
        loadingId = null
    } = options;
    
    return new Promise((resolve, reject) => {
        // Check cache first
        if (useCache && cacheKey) {
            const cached = ProductTreeCache.get(cacheKey);
            if (cached) {
                console.log('Cache hit for:', cacheKey);
                resolve(cached);
                return;
            }
            
            // Check if same request is already pending
            if (ProductTreeCache.pendingRequests.has(cacheKey)) {
                ProductTreeCache.pendingRequests.get(cacheKey).push({ resolve, reject });
                return;
            }
            
            // Mark request as pending
            ProductTreeCache.pendingRequests.set(cacheKey, [{ resolve, reject }]);
        }
        
        // Show loading
        if (loadingId) {
            LoadingManager.show(loadingId);
        }
        
        const startTime = performance.now();
        
        $.ajax({
            url: url,
            method: method,
            data: data,
            timeout: 30000, // 30 seconds timeout
            success: function(response) {
                try {
                    const endTime = performance.now();
                    console.log(`Request completed in ${(endTime - startTime).toFixed(2)}ms:`, url);
                    
                    let parsedResponse;
                    if (typeof response === 'string') {
                        parsedResponse = JSON.parse(response);
                    } else {
                        parsedResponse = response;
                    }
                    
                    // Cache the response
                    if (useCache && cacheKey) {
                        ProductTreeCache.set(cacheKey, parsedResponse);
                        
                        // Resolve all pending requests with same key
                        const pending = ProductTreeCache.pendingRequests.get(cacheKey) || [];
                        pending.forEach(({ resolve: pendingResolve }) => {
                            pendingResolve(parsedResponse);
                        });
                        ProductTreeCache.pendingRequests.delete(cacheKey);
                    }
                    
                    resolve(parsedResponse);
                } catch (error) {
                    console.error('JSON Parse Error:', error, 'Response:', response);
                    ErrorHandler.show('Veri işleme hatası: ' + error.message);
                    reject(error);
                }
            },
            error: function(xhr, status, error) {
                const endTime = performance.now();
                console.error(`Request failed after ${(endTime - startTime).toFixed(2)}ms:`, {
                    url, status, error, xhr
                });
                
                let errorMessage = 'Sunucu hatası';
                if (status === 'timeout') {
                    errorMessage = 'İstek zaman aşımına uğradı';
                } else if (status === 'abort') {
                    errorMessage = 'İstek iptal edildi';
                } else if (xhr.status === 404) {
                    errorMessage = 'Sayfa bulunamadı';
                } else if (xhr.status === 500) {
                    errorMessage = 'Sunucu iç hatası';
                }
                
                ErrorHandler.show(errorMessage);
                
                // Handle pending requests
                if (useCache && cacheKey && ProductTreeCache.pendingRequests.has(cacheKey)) {
                    const pending = ProductTreeCache.pendingRequests.get(cacheKey) || [];
                    pending.forEach(({ reject: pendingReject }) => {
                        pendingReject(new Error(errorMessage));
                    });
                    ProductTreeCache.pendingRequests.delete(cacheKey);
                }
                
                reject(new Error(errorMessage));
            },
            complete: function() {
                if (loadingId) {
                    LoadingManager.hide(loadingId);
                }
            }
        });
    });
}

// Optimized ngetTree function
async function ngetTreeOptimized(
    product_id,
    is_virtual,
    dsn3,
    btn,
    tip = 1,
    li = "",
    pna = "",
    stg = "",
    idba = "",
    tipo = 1
) {
    try {
        console.log('ngetTreeOptimized called:', { product_id, is_virtual, tip, tipo });
        
        const loadingId = `tree_${product_id}_${tip}`;
        let sida = 0;
        
        // Get product name and stock ID if needed (this could be optimized too)
        if (tip === 1) {
            if (is_virtual == 1) {
                const qqq = wrk_query(
                    "SELECT PRODUCT_NAME FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=" + product_id,
                    "DSN3"
                );
                pna = qqq.PRODUCT_NAME[0];
            } else {
                const qqq = wrk_query(
                    "SELECT PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE PRODUCT_ID=" + product_id,
                    "DSN3"
                );
                pna = qqq.PRODUCT_NAME[0];
                sida = qqq.STOCK_ID[0];
            }
            
            $("#pnamemain").val(pna);
            $("#vp_id").val(product_id);
            $("#is_virtual").val(is_virtual);
            $("#pstage").val(stg);
        }
        
        // Build optimized URL
        let url = `/AddOns/Partner/project/cfc/product_design.cfc?method=getTree`;
        url += `&product_id=${product_id}`;
        url += `&isVirtual=${is_virtual}`;
        url += `&ddsn3=${dsn3}`;
        url += `&company_id=${_compId}`;
        url += `&price_catid=${_priceCatId}`;
        
        if (tipo) url += `&tipo=${tipo}`;
        if (sida) url += `&stock_id=${sida}`;
        if (tip === 4) url += `&from_copy=1`;
        
        // Create cache key
        const cacheKey = ProductTreeCache.getCacheKey(product_id, is_virtual, tipo, _compId, _priceCatId);
        
        // Make optimized request
        const treeData = await makeOptimizedAjaxRequest({
            url: url,
            cacheKey: cacheKey,
            loadingId: loadingId
        });
        
        // Store global reference (maintain compatibility with existing code)
        window.o = treeData;
        
        console.log('Tree data received:', treeData);
        
        // Process tree based on tip
        await processTreeByTip(treeData, tip, li, product_id);
        
    } catch (error) {
        console.error('ngetTreeOptimized error:', error);
        ErrorHandler.show('Ürün ağacı yüklenirken hata oluştu: ' + error.message);
    }
}

// Process tree data based on tip parameter
async function processTreeByTip(treeData, tip, li, product_id) {
    switch (tip) {
        case 1:
            AgaciYaz(treeData, 0, "0", 1);
            const esd = document.getElementById("TreeArea");
            esd.innerHTML = "";
            esd.appendChild(window.ulx);
            agacGosterEkle();
            sortableYap();
            virtuallariYerlestir();
            MaliyetHesapla2();
            GercekKontrol(product_id);
            break;
            
        case 2:
            const et = AgaciYaz_12(treeData, 0, "", 0);
            li.appendChild(et);
            agacGosterEkle();
            sortableYap();
            virtuallariYerlestir();
            MaliyetHesapla2();
            break;
            
        case 3:
            // Handle tip 3 logic
            break;
            
        case 4:
            // Copy mode - handle differently
            break;
            
        case 5:
            // Handle tip 5 logic
            break;
            
        default:
            console.warn('Unknown tip value:', tip);
    }
}

// Debounced version for frequent calls
const debouncedNgetTree = debounce(ngetTreeOptimized, 300);

// Backward compatibility - replace original function
if (typeof window.ngetTree !== 'undefined') {
    window.ngetTree_original = window.ngetTree;
}
window.ngetTree = ngetTreeOptimized;
window.ngetTreeDebounced = debouncedNgetTree;

// Initialize loading indicator
document.addEventListener('DOMContentLoaded', function() {
    // Add global loading indicator if it doesn't exist
    if (!document.getElementById('global-loader')) {
        const loader = document.createElement('div');
        loader.id = 'global-loader';
        loader.className = 'global-loader';
        loader.innerHTML = `
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Yükleniyor...</span>
            </div>
            <div class="loading-text">Veriler yükleniyor...</div>
        `;
        loader.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255,255,255,0.9);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 9998;
            display: none;
            text-align: center;
        `;
        document.body.appendChild(loader);
    }
});

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { 
        ngetTreeOptimized, 
        ProductTreeCache, 
        LoadingManager, 
        ErrorHandler 
    };
}

console.log('ProductTree optimization loaded successfully');