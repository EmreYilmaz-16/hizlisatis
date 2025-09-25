/**
 * Enhanced Feature Manager
 * Manages advanced features like bulk operations, filtering, exports, and user preferences
 */

class EnhancedFeatureManager {
    constructor() {
        this.bulkManager = new BulkOperationsManager();
        this.filterManager = new AdvancedFilterManager();
        this.exportManager = new DataExportManager();
        this.preferencesManager = new UserPreferencesManager();
        this.workflowManager = new WorkflowAutomationManager();
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadUserPreferences();
        this.initializeComponents();
    }

    // Alias for compatibility
    initialize() {
        return this.init();
    }

    setupEventListeners() {
        // Bulk operations events
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-bulk-action]')) {
                e.preventDefault();
                this.handleBulkOperation(e.target);
            }
        });

        // Filter events
        document.addEventListener('change', (e) => {
            if (e.target.matches('[data-filter-field]')) {
                this.filterManager.handleFilterChange(e.target);
            }
        });

        // Export events
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-export-action]')) {
                e.preventDefault();
                this.handleExportOperation(e.target);
            }
        });

        // Preference events
        document.addEventListener('change', (e) => {
            if (e.target.matches('[data-preference]')) {
                this.preferencesManager.savePreference(e.target);
            }
        });
    }

    async loadUserPreferences() {
        try {
            const preferences = await this.preferencesManager.loadPreferences();
            this.applyPreferences(preferences);
        } catch (error) {
            console.error('Error loading preferences:', error);
        }
    }

    applyPreferences(preferences) {
        try {
            if (!preferences) return;
            
            // Apply UI preferences
            if (preferences.theme) {
                document.body.setAttribute('data-theme', preferences.theme);
            }
            
            // Apply filter preferences
            if (preferences.defaultFilters) {
                this.filterManager.applyDefaultFilters(preferences.defaultFilters);
            }
            
            // Apply display preferences
            if (preferences.display) {
                this.applyDisplayPreferences(preferences.display);
            }
            
            // Apply notification preferences
            if (preferences.notifications) {
                this.applyNotificationPreferences(preferences.notifications);
            }
            
            console.log('User preferences applied successfully');
        } catch (error) {
            console.error('Error applying preferences:', error);
        }
    }

    applyDisplayPreferences(displayPrefs) {
        if (displayPrefs.compactView) {
            document.body.classList.add('compact-view');
        }
        if (displayPrefs.fontSize) {
            document.documentElement.style.setProperty('--font-size-base', displayPrefs.fontSize + 'px');
        }
    }

    applyNotificationPreferences(notifPrefs) {
        // Apply notification settings
        if (notifPrefs.enabled === false) {
            document.body.classList.add('notifications-disabled');
        }
    }

    initializeComponents() {
        this.initBulkOperations();
        this.initAdvancedFilters();
        this.initExportSystem();
        this.initPreferencesPanel();
        this.initWorkflowAutomation();
    }

    // Bulk Operations Management
    initBulkOperations() {
        const bulkPanel = document.getElementById('bulkOperationsPanel');
        if (!bulkPanel) return;

        bulkPanel.innerHTML = `
            <div class="bulk-operations-header">
                <h5><i class="fas fa-tasks me-2"></i>Toplu İşlemler</h5>
                <button class="btn btn-sm btn-outline-secondary" onclick="enhancedFeatures.toggleBulkPanel()">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="bulk-operations-content" style="display: none;">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>İşlem Türü</label>
                            <select class="form-select" id="bulkOperation">
                                <option value="">Seçiniz...</option>
                                <option value="updatePrices">Fiyat Güncelle</option>
                                <option value="updateStatus">Durum Güncelle</option>
                                <option value="updateCategories">Kategori Güncelle</option>
                                <option value="deleteProducts">Ürün Sil</option>
                                <option value="copyProducts">Ürün Kopyala</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Seçili Öğeler</label>
                            <div class="selected-items">
                                <span class="badge bg-primary" id="selectedCount">0 öğe seçili</span>
                                <button class="btn btn-sm btn-outline-danger ms-2" onclick="enhancedFeatures.clearSelection()">
                                    <i class="fas fa-times"></i> Temizle
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="bulk-operation-details" id="bulkOperationDetails" style="display: none;">
                    <!-- Operation-specific form fields will be loaded here -->
                </div>
                
                <div class="bulk-actions mt-3">
                    <button class="btn btn-primary me-2" onclick="enhancedFeatures.executeBulkOperation()">
                        <i class="fas fa-play me-2"></i>İşlemi Başlat
                    </button>
                    <button class="btn btn-secondary" onclick="enhancedFeatures.previewBulkOperation()">
                        <i class="fas fa-eye me-2"></i>Önizleme
                    </button>
                </div>
                
                <div class="bulk-progress mt-3" id="bulkProgress" style="display: none;">
                    <div class="progress">
                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                    </div>
                    <div class="progress-info mt-2">
                        <small class="text-muted" id="progressText">İşlem başlatılıyor...</small>
                    </div>
                </div>
            </div>
        `;

        this.setupBulkOperationHandlers();
    }

    setupBulkOperationHandlers() {
        // Operation type change handler
        document.getElementById('bulkOperation').addEventListener('change', (e) => {
            this.loadBulkOperationForm(e.target.value);
        });

        // Checkbox selection handler
        document.addEventListener('change', (e) => {
            if (e.target.matches('.product-checkbox')) {
                this.updateSelectedItems();
            }
        });

        // Select all handler
        document.addEventListener('change', (e) => {
            if (e.target.matches('#selectAllProducts')) {
                this.toggleSelectAll(e.target.checked);
            }
        });
    }

    loadBulkOperationForm(operationType) {
        const detailsPanel = document.getElementById('bulkOperationDetails');
        if (!operationType) {
            detailsPanel.style.display = 'none';
            return;
        }

        let formHTML = '';
        switch (operationType) {
            case 'updatePrices':
                formHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Yeni Fiyat</label>
                                <input type="number" class="form-control" id="newPrice" step="0.01" min="0">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>İndirim Oranı (%)</label>
                                <input type="number" class="form-control" id="discountRate" step="0.01" min="0" max="100">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="applyToVariants">
                            <label class="form-check-label" for="applyToVariants">
                                Varyantlara da uygula
                            </label>
                        </div>
                    </div>
                `;
                break;
            case 'updateStatus':
                formHTML = `
                    <div class="form-group">
                        <label>Yeni Durum</label>
                        <select class="form-select" id="newStatus">
                            <option value="1">Aktif</option>
                            <option value="0">Pasif</option>
                        </select>
                    </div>
                `;
                break;
            case 'updateCategories':
                formHTML = `
                    <div class="form-group">
                        <label>Yeni Kategori</label>
                        <select class="form-select" id="newCategory">
                            <!-- Categories will be loaded dynamically -->
                        </select>
                    </div>
                `;
                this.loadCategories('newCategory');
                break;
            case 'copyProducts':
                formHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Hedef Kategori</label>
                                <select class="form-select" id="targetCategory">
                                    <!-- Categories will be loaded dynamically -->
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>İsim Ön Eki</label>
                                <input type="text" class="form-control" id="namePrefix" placeholder="Kopya_">
                            </div>
                        </div>
                    </div>
                `;
                this.loadCategories('targetCategory');
                break;
        }

        detailsPanel.innerHTML = formHTML;
        detailsPanel.style.display = formHTML ? 'block' : 'none';
    }

    // Advanced Filtering System
    initAdvancedFilters() {
        const filterPanel = document.getElementById('advancedFilterPanel');
        if (!filterPanel) return;

        filterPanel.innerHTML = `
            <div class="advanced-filter-header">
                <h5><i class="fas fa-filter me-2"></i>Gelişmiş Filtreler</h5>
                <button class="btn btn-sm btn-outline-secondary" onclick="enhancedFeatures.toggleFilterPanel()">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="advanced-filter-content">
                <form id="advancedFilterForm">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Ürün Adı</label>
                                <input type="text" class="form-control" name="searchText" data-filter-field="searchText">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Kategori</label>
                                <select class="form-select" name="categoryIds" data-filter-field="categoryIds" multiple>
                                    <!-- Categories loaded dynamically -->
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Durum</label>
                                <select class="form-select" name="status" data-filter-field="status">
                                    <option value="">Tümü</option>
                                    <option value="active">Aktif</option>
                                    <option value="inactive">Pasif</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Min Fiyat</label>
                                <input type="number" class="form-control" name="minPrice" data-filter-field="minPrice" step="0.01">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Max Fiyat</label>
                                <input type="number" class="form-control" name="maxPrice" data-filter-field="maxPrice" step="0.01">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Ürün Türü</label>
                                <select class="form-select" name="productType" data-filter-field="productType">
                                    <option value="">Tümü</option>
                                    <option value="virtual">Virtual</option>
                                    <option value="real">Real</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>Tarih Aralığı</label>
                                <input type="date" class="form-control" name="startDate" data-filter-field="startDate">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="filter-actions">
                                <button type="button" class="btn btn-primary me-2" onclick="enhancedFeatures.applyFilters()">
                                    <i class="fas fa-search me-2"></i>Filtrele
                                </button>
                                <button type="button" class="btn btn-secondary me-2" onclick="enhancedFeatures.clearFilters()">
                                    <i class="fas fa-eraser me-2"></i>Temizle
                                </button>
                                <button type="button" class="btn btn-outline-info" onclick="enhancedFeatures.saveFilterPreset()">
                                    <i class="fas fa-save me-2"></i>Kaydet
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
                
                <div class="saved-filters mt-3">
                    <h6>Kayıtlı Filtreler</h6>
                    <div id="filterPresets">
                        <!-- Saved filter presets will be loaded here -->
                    </div>
                </div>
            </div>
        `;

        this.loadCategories('categoryIds');
        this.loadFilterPresets();
    }

    // Data Export System
    initExportSystem() {
        const exportPanel = document.getElementById('dataExportPanel');
        if (!exportPanel) return;

        exportPanel.innerHTML = `
            <div class="export-header">
                <h5><i class="fas fa-download me-2"></i>Veri Dışa Aktarma</h5>
                <button class="btn btn-sm btn-outline-secondary" onclick="enhancedFeatures.toggleExportPanel()">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="export-content" style="display: none;">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Export Türü</label>
                            <select class="form-select" id="exportType">
                                <option value="products">Ürünler</option>
                                <option value="categories">Kategoriler</option>
                                <option value="pricing">Fiyatlandırma</option>
                                <option value="inventory">Envanter</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Format</label>
                            <select class="form-select" id="exportFormat">
                                <option value="excel">Excel (.xlsx)</option>
                                <option value="csv">CSV</option>
                                <option value="pdf">PDF</option>
                                <option value="json">JSON</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button class="btn btn-success w-100" onclick="enhancedFeatures.startExport()">
                                <i class="fas fa-download me-2"></i>Dışa Aktar
                            </button>
                        </div>
                    </div>
                </div>
                
                <div class="export-options mt-3">
                    <h6>Export Seçenekleri</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Sütunlar</label>
                                <div class="form-check-group">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="col_name" value="PRODUCT_NAME" checked>
                                        <label class="form-check-label" for="col_name">Ürün Adı</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="col_category" value="CATEGORY_NAME" checked>
                                        <label class="form-check-label" for="col_category">Kategori</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="col_price" value="PRODUCT_UNIT_PRICE" checked>
                                        <label class="form-check-label" for="col_price">Fiyat</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="col_status" value="STATUS">
                                        <label class="form-check-label" for="col_status">Durum</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Ek Seçenekler</label>
                                <div class="form-check-group">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="includeDeleted">
                                        <label class="form-check-label" for="includeDeleted">Silinenleri dahil et</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="applyCurrentFilters" checked>
                                        <label class="form-check-label" for="applyCurrentFilters">Mevcut filtreleri uygula</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="includeImages">
                                        <label class="form-check-label" for="includeImages">Resimleri dahil et</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="export-progress mt-3" id="exportProgress" style="display: none;">
                    <div class="progress">
                        <div class="progress-bar" role="progressbar"></div>
                    </div>
                    <div class="export-status mt-2">
                        <small class="text-muted" id="exportStatus">Export başlatılıyor...</small>
                    </div>
                </div>
                
                <div class="recent-exports mt-3">
                    <h6>Son Exportlar</h6>
                    <div id="recentExportsList">
                        <!-- Recent exports will be loaded here -->
                    </div>
                </div>
            </div>
        `;

        this.loadRecentExports();
    }

    // User Preferences System
    initPreferencesPanel() {
        const preferencesPanel = document.getElementById('userPreferencesPanel');
        if (!preferencesPanel) return;

        preferencesPanel.innerHTML = `
            <div class="preferences-header">
                <h5><i class="fas fa-cog me-2"></i>Kullanıcı Tercihleri</h5>
                <button class="btn btn-sm btn-outline-secondary" onclick="enhancedFeatures.togglePreferencesPanel()">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="preferences-content" style="display: none;">
                <div class="preferences-tabs">
                    <ul class="nav nav-tabs" id="preferencesTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="display-tab" data-bs-toggle="tab" href="#display" role="tab">Görünüm</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="behavior-tab" data-bs-toggle="tab" href="#behavior" role="tab">Davranış</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="notifications-tab" data-bs-toggle="tab" href="#notifications" role="tab">Bildirimler</a>
                        </li>
                    </ul>
                    
                    <div class="tab-content mt-3">
                        <div class="tab-pane fade show active" id="display" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Tema</label>
                                        <select class="form-select" data-preference="theme">
                                            <option value="light">Açık</option>
                                            <option value="dark">Koyu</option>
                                            <option value="auto">Otomatik</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Dil</label>
                                        <select class="form-select" data-preference="language">
                                            <option value="tr">Türkçe</option>
                                            <option value="en">English</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Sayfa Boyutu</label>
                                        <select class="form-select" data-preference="pageSize">
                                            <option value="10">10</option>
                                            <option value="25">25</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Varsayılan Görünüm</label>
                                        <select class="form-select" data-preference="defaultView">
                                            <option value="tree">Ağaç</option>
                                            <option value="list">Liste</option>
                                            <option value="grid">Kart</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" data-preference="compactView" id="compactView">
                                    <label class="form-check-label" for="compactView">Kompakt görünüm</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-pane fade" id="behavior" role="tabpanel">
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" data-preference="autoSave" id="autoSave">
                                    <label class="form-check-label" for="autoSave">Otomatik kaydet</label>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" data-preference="showTutorials" id="showTutorials">
                                    <label class="form-check-label" for="showTutorials">Yardım ipuçlarını göster</label>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Para Birimi</label>
                                <select class="form-select" data-preference="currency">
                                    <option value="TRY">TRY</option>
                                    <option value="USD">USD</option>
                                    <option value="EUR">EUR</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="tab-pane fade" id="notifications" role="tabpanel">
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" data-preference="notifications" id="notifications">
                                    <label class="form-check-label" for="notifications">Bildirimleri etkinleştir</label>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" data-preference="soundEnabled" id="soundEnabled">
                                    <label class="form-check-label" for="soundEnabled">Ses bildirimleri</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="preferences-actions mt-3">
                    <button class="btn btn-primary me-2" onclick="enhancedFeatures.saveAllPreferences()">
                        <i class="fas fa-save me-2"></i>Tercihleri Kaydet
                    </button>
                    <button class="btn btn-secondary me-2" onclick="enhancedFeatures.resetPreferences()">
                        <i class="fas fa-undo me-2"></i>Varsayılana Dön
                    </button>
                    <button class="btn btn-outline-info" onclick="enhancedFeatures.exportPreferences()">
                        <i class="fas fa-download me-2"></i>Export Et
                    </button>
                </div>
            </div>
        `;
    }

    // Workflow Automation System
    initWorkflowAutomation() {
        const workflowPanel = document.getElementById('workflowAutomationPanel');
        if (!workflowPanel) return;

        workflowPanel.innerHTML = `
            <div class="workflow-header">
                <h5><i class="fas fa-cogs me-2"></i>İş Akışı Otomasyonu</h5>
                <button class="btn btn-sm btn-outline-secondary" onclick="enhancedFeatures.toggleWorkflowPanel()">
                    <i class="fas fa-chevron-down"></i>
                </button>
            </div>
            <div class="workflow-content" style="display: none;">
                <div class="automation-rules">
                    <h6>Otomasyon Kuralları</h6>
                    <div class="rule-list" id="automationRules">
                        <!-- Automation rules will be loaded here -->
                    </div>
                    
                    <button class="btn btn-primary" onclick="enhancedFeatures.createNewRule()">
                        <i class="fas fa-plus me-2"></i>Yeni Kural Oluştur
                    </button>
                </div>
                
                <div class="scheduled-tasks mt-3">
                    <h6>Zamanlanmış Görevler</h6>
                    <div class="task-list" id="scheduledTasks">
                        <!-- Scheduled tasks will be loaded here -->
                    </div>
                </div>
            </div>
        `;

        this.loadAutomationRules();
        this.loadScheduledTasks();
    }

    // Helper methods for feature operations
    async handleBulkOperation(button) {
        const operation = button.getAttribute('data-bulk-action');
        const selectedItems = this.getSelectedItems();
        
        if (selectedItems.length === 0) {
            this.showNotification('Lütfen işlem yapılacak öğeleri seçiniz.', 'warning');
            return;
        }

        // Show confirmation dialog
        if (!await this.confirmBulkOperation(operation, selectedItems.length)) {
            return;
        }

        try {
            this.showBulkProgress(true);
            const result = await this.bulkManager.executeOperation(operation, selectedItems);
            
            if (result.success) {
                this.showNotification(`${result.successCount} öğe başarıyla işlendi.`, 'success');
                this.refreshProductList();
            } else {
                this.showNotification(`İşlem başarısız: ${result.message}`, 'error');
            }
        } catch (error) {
            console.error('Bulk operation error:', error);
            this.showNotification('Toplu işlem sırasında hata oluştu.', 'error');
        } finally {
            this.showBulkProgress(false);
        }
    }

    async handleExportOperation(button) {
        const exportType = document.getElementById('exportType').value;
        const format = document.getElementById('exportFormat').value;
        const selectedColumns = this.getSelectedExportColumns();
        
        try {
            this.showExportProgress(true);
            const result = await this.exportManager.exportData(exportType, format, selectedColumns);
            
            if (result.success) {
                this.showNotification('Export başarıyla tamamlandı.', 'success');
                this.addToRecentExports(result);
                
                // Trigger download
                if (result.downloadUrl) {
                    window.open(result.downloadUrl, '_blank');
                }
            } else {
                this.showNotification(`Export başarısız: ${result.message}`, 'error');
            }
        } catch (error) {
            console.error('Export error:', error);
            this.showNotification('Export sırasında hata oluştu.', 'error');
        } finally {
            this.showExportProgress(false);
        }
    }

    // Utility methods
    getSelectedItems() {
        const checkboxes = document.querySelectorAll('.product-checkbox:checked');
        return Array.from(checkboxes).map(cb => cb.value);
    }

    getSelectedExportColumns() {
        const checkboxes = document.querySelectorAll('[id^="col_"]:checked');
        return Array.from(checkboxes).map(cb => cb.value);
    }

    showNotification(message, type = 'info') {
        // Implementation for showing notifications
        console.log(`[${type.toUpperCase()}] ${message}`);
    }

    showBulkProgress(show) {
        const progressPanel = document.getElementById('bulkProgress');
        if (progressPanel) {
            progressPanel.style.display = show ? 'block' : 'none';
        }
    }

    showExportProgress(show) {
        const progressPanel = document.getElementById('exportProgress');
        if (progressPanel) {
            progressPanel.style.display = show ? 'block' : 'none';
        }
    }

    // Toggle panel methods
    toggleBulkPanel() {
        const content = document.querySelector('.bulk-operations-content');
        if (content) {
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    }

    toggleFilterPanel() {
        const content = document.querySelector('.advanced-filter-content');
        if (content) {
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    }

    toggleExportPanel() {
        const content = document.querySelector('.export-content');
        if (content) {
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    }

    togglePreferencesPanel() {
        const content = document.querySelector('.preferences-content');
        if (content) {
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    }

    toggleWorkflowPanel() {
        const content = document.querySelector('.workflow-content');
        if (content) {
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    }

    async loadCategories(selectId) {
        // Implementation to load categories into select element
        console.log(`Loading categories for ${selectId}`);
    }

    async loadFilterPresets() {
        // Implementation to load saved filter presets
        console.log('Loading filter presets');
    }

    async loadRecentExports() {
        // Implementation to load recent exports
        console.log('Loading recent exports');
    }

    async loadAutomationRules() {
        // Implementation to load automation rules
        console.log('Loading automation rules');
    }

    async loadScheduledTasks() {
        // Implementation to load scheduled tasks
        console.log('Loading scheduled tasks');
    }
}

// Individual feature managers (simplified implementations)
class BulkOperationsManager {
    async executeOperation(operation, items) {
        // Implementation for bulk operations
        return { success: true, successCount: items.length };
    }
}

class AdvancedFilterManager {
    handleFilterChange(element) {
        // Implementation for filter changes
        console.log('Filter changed:', element.name, element.value);
    }
}

class DataExportManager {
    async exportData(type, format, columns) {
        // Implementation for data export
        return { 
            success: true, 
            downloadUrl: `/exports/${type}_export_${Date.now()}.${format}` 
        };
    }
}

class UserPreferencesManager {
    async loadPreferences() {
        // Implementation for loading preferences
        return {};
    }

    savePreference(element) {
        // Implementation for saving individual preference
        console.log('Saving preference:', element.getAttribute('data-preference'), element.value);
    }

    // Alias method for compatibility
    initialize() {
        return this.init();
    }
}

class WorkflowAutomationManager {
    // Implementation for workflow automation
}

// Export classes to global scope
if (typeof window !== 'undefined') {
    window.EnhancedFeatureManager = EnhancedFeatureManager;
    window.WorkflowAutomationManager = WorkflowAutomationManager;
}

// Note: Manual initialization is handled in product_design.cfm
// No automatic DOM loading initialization to avoid conflicts

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = EnhancedFeatureManager;
}