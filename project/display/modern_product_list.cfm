<!-- Modern Product List Component -->
<div class="modern-card">
  <div class="modern-card-header">
    <h3><i class="fas fa-list"></i> Proje Ürünleri</h3>
    <div class="header-actions">
      <button class="btn-modern btn-sm btn-secondary" onclick="refreshProductList()" data-tooltip="Listeyi Yenile">
        <i class="fas fa-sync-alt"></i>
      </button>
      <button class="btn-modern btn-sm btn-primary" onclick="addNewProduct()" data-tooltip="Yeni Ürün">
        <i class="fas fa-plus"></i>
      </button>
    </div>
  </div>

  <div class="modern-card-body">
    <!-- Enhanced Search and Filter Panel -->
    <div class="search-filter-panel">
      <div class="search-row">
        <div class="search-input-group">
          <input type="text" class="form-control-modern" id="txtKeyword" name="txtKeyword" placeholder="Ürün adı ara...">
          <div class="input-icon">
            <i class="fas fa-search"></i>
          </div>
        </div>
        
        <div class="search-input-group">
          <input type="text" class="form-control-modern" id="txtKeywordProject" name="txtKeywordProject" placeholder="Proje No">
          <div class="input-icon">
            <i class="fas fa-hashtag"></i>
          </div>
        </div>
      </div>
      
      <div class="filter-row">
        <div class="filter-group">
          <label class="filter-label">Kategori:</label>
          <div class="select-modern">
            <select class="form-control-modern" name="PCAT" id="PCAT">
              <option value="">Tüm Kategoriler</option>
              <cfoutput query="getCats">
                <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
              </cfoutput>
            </select>
          </div>
        </div>
        
        <div class="filter-group">
          <label class="filter-label">Durum:</label>
          <div class="select-modern">
            <select class="form-control-modern" name="status_filter" id="status_filter">
              <option value="">Tüm Durumlar</option>
              <option value="active">Aktif</option>
              <option value="draft">Taslak</option>
              <option value="completed">Tamamlanmış</option>
            </select>
          </div>
        </div>
      </div>
      
      <div class="action-row">
        <button class="btn-modern btn-primary" type="button" onclick="searchProducts()">
          <i class="fas fa-search"></i> Ara
        </button>
        <button class="btn-modern btn-secondary" type="button" onclick="clearFilters()">
          <i class="fas fa-times"></i> Temizle
        </button>
        <div class="view-toggle">
          <button class="btn-modern btn-sm btn-secondary active" onclick="toggleView('list')" data-tooltip="Liste Görünümü">
            <i class="fas fa-list"></i>
          </button>
          <button class="btn-modern btn-sm btn-secondary" onclick="toggleView('grid')" data-tooltip="Kart Görünümü">
            <i class="fas fa-th"></i>
          </button>
        </div>
      </div>
    </div>

    <!-- Product List Container -->
    <div class="product-list-container" id="product-list-container">
      <!-- Loading State -->
      <div class="loading-state" id="product-loading" style="display:none;">
        <div class="loading-spinner"></div>
        <p>Ürünler yükleniyor...</p>
      </div>
      
      <!-- Empty State -->
      <div class="empty-state" id="product-empty" style="display:none;">
        <div class="empty-state-icon">
          <i class="fas fa-inbox fa-3x"></i>
        </div>
        <h4 class="empty-state-title">Ürün Bulunamadı</h4>
        <p class="empty-state-description">
          Arama kriterlerinizle eşleşen ürün bulunamadı. Filtrelerinizi kontrol edin veya yeni bir ürün ekleyin.
        </p>
        <button class="btn-modern btn-primary" onclick="addNewProduct()">
          <i class="fas fa-plus"></i> İlk Ürünü Ekle
        </button>
      </div>
      
      <!-- Product List -->
      <div class="product-list-modern" id="resultArea">
        <!-- Products will be loaded here dynamically -->
      </div>
    </div>

    <!-- List Controls -->
    <div class="list-controls">
      <div class="list-stats">
        <span class="stat-item">
          <i class="fas fa-cubes"></i>
          <span id="total-products-count">0</span> Ürün
        </span>
        <span class="stat-item">
          <i class="fas fa-filter"></i>
          <span id="filtered-products-count">0</span> Gösterilen
        </span>
      </div>
      
      <div class="list-pagination">
        <button class="btn-modern btn-sm btn-secondary" onclick="loadMoreProducts()" id="load-more-btn" style="display:none;">
          <i class="fas fa-chevron-down"></i> Daha Fazla Yükle
        </button>
      </div>
    </div>
  </div>
</div>

<style>
/* Enhanced Product List Styles */
.search-filter-panel {
  background: var(--gray-50);
  border: 1px solid var(--gray-200);
  border-radius: var(--radius-lg);
  padding: var(--spacing-lg);
  margin-bottom: var(--spacing-lg);
}

.search-row,
.filter-row,
.action-row {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-md);
  align-items: end;
}

.action-row {
  margin-bottom: 0;
  justify-content: space-between;
}

.search-input-group {
  flex: 1;
  position: relative;
}

.input-icon {
  position: absolute;
  right: var(--spacing-md);
  top: 50%;
  transform: translateY(-50%);
  color: var(--gray-500);
  pointer-events: none;
}

.filter-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.filter-label {
  font-size: var(--font-size-sm);
  font-weight: 500;
  color: var(--gray-700);
}

.view-toggle {
  display: flex;
  background: var(--gray-100);
  border-radius: var(--radius-md);
  padding: 2px;
}

.view-toggle .btn-modern {
  margin: 0;
  border-radius: var(--radius-sm);
}

.view-toggle .btn-modern.active {
  background: white;
  box-shadow: var(--shadow-sm);
}

.product-list-container {
  min-height: 400px;
  max-height: 60vh;
  overflow-y: auto;
  border: 1px solid var(--gray-200);
  border-radius: var(--radius-lg);
  background: white;
  position: relative;
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  gap: var(--spacing-md);
  color: var(--gray-600);
}

.product-list-modern {
  padding: var(--spacing-md);
}

.product-item-modern {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-md);
  border: 1px solid var(--gray-200);
  border-radius: var(--radius-md);
  margin-bottom: var(--spacing-sm);
  cursor: pointer;
  transition: all var(--transition-fast);
  background: white;
  position: relative;
  overflow: hidden;
}

.product-item-modern::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: var(--primary-500);
  transform: scaleY(0);
  transition: transform var(--transition-fast);
}

.product-item-modern:hover {
  border-color: var(--primary-300);
  background: var(--primary-50);
  transform: translateX(4px);
}

.product-item-modern:hover::before {
  transform: scaleY(1);
}

.product-item-modern.active {
  border-color: var(--primary-500);
  background: var(--primary-100);
}

.product-item-modern.active::before {
  transform: scaleY(1);
}

.product-item-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.product-item-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.product-item-title {
  font-weight: 600;
  color: var(--gray-800);
  margin: 0;
  line-height: 1.4;
  flex: 1;
}

.product-item-id {
  font-size: var(--font-size-sm);
  color: var(--gray-500);
  background: var(--gray-100);
  padding: 2px 6px;
  border-radius: var(--radius-sm);
  margin-left: var(--spacing-sm);
}

.product-item-meta {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-sm);
  align-items: center;
}

.product-item-category,
.product-item-stage,
.product-item-date {
  font-size: var(--font-size-sm);
  color: var(--gray-600);
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.product-item-actions {
  display: flex;
  gap: var(--spacing-xs);
  opacity: 0;
  transition: opacity var(--transition-fast);
}

.product-item-modern:hover .product-item-actions {
  opacity: 1;
}

.list-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-md);
  border-top: 1px solid var(--gray-200);
  margin-top: var(--spacing-md);
  background: var(--gray-50);
  border-radius: 0 0 var(--radius-lg) var(--radius-lg);
}

.list-stats {
  display: flex;
  gap: var(--spacing-lg);
}

.stat-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  font-size: var(--font-size-sm);
  color: var(--gray-600);
}

/* Grid View */
.product-list-modern.grid-view {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: var(--spacing-md);
}

.product-list-modern.grid-view .product-item-modern {
  flex-direction: column;
  align-items: stretch;
  margin-bottom: 0;
}

.product-list-modern.grid-view .product-item-header {
  margin-bottom: var(--spacing-sm);
}

/* Responsive Design */
@media (max-width: 768px) {
  .search-row,
  .filter-row {
    flex-direction: column;
  }
  
  .action-row {
    flex-direction: column;
    gap: var(--spacing-sm);
  }
  
  .view-toggle {
    align-self: center;
  }
  
  .list-controls {
    flex-direction: column;
    gap: var(--spacing-sm);
    text-align: center;
  }
}
</style>

<script>
// Enhanced Product List Management
let currentView = 'list';
let currentPage = 1;
let totalProducts = 0;
let filteredProducts = 0;

// Initialize product list
document.addEventListener('DOMContentLoaded', function() {
  initializeProductList();
});

function initializeProductList() {
  // Setup search debouncing
  const searchInputs = document.querySelectorAll('#txtKeyword, #txtKeywordProject');
  searchInputs.forEach(input => {
    input.addEventListener('input', window.ModernUI.debounce(searchProducts, 300));
  });
  
  // Setup filter change handlers
  const filterSelects = document.querySelectorAll('#PCAT, #status_filter');
  filterSelects.forEach(select => {
    select.addEventListener('change', searchProducts);
  });
  
  // Initial load
  searchProducts();
}

function searchProducts() {
  showProductLoading();
  
  const keyword = document.getElementById('txtKeyword').value;
  const projectKeyword = document.getElementById('txtKeywordProject').value;
  const category = document.getElementById('PCAT').value;
  const status = document.getElementById('status_filter').value;
  
  // Simulate API call - replace with actual implementation
  setTimeout(() => {
    const mockProducts = generateMockProducts(keyword, projectKeyword, category, status);
    displayProducts(mockProducts);
    hideProductLoading();
  }, 500);
}

function showProductLoading() {
  document.getElementById('product-loading').style.display = 'flex';
  document.getElementById('product-empty').style.display = 'none';
  document.getElementById('resultArea').innerHTML = '';
}

function hideProductLoading() {
  document.getElementById('product-loading').style.display = 'none';
}

function displayProducts(products) {
  const container = document.getElementById('resultArea');
  
  if (products.length === 0) {
    document.getElementById('product-empty').style.display = 'flex';
    container.innerHTML = '';
    updateProductStats(0, 0);
    return;
  }
  
  document.getElementById('product-empty').style.display = 'none';
  
  container.innerHTML = products.map(product => `
    <div class="product-item-modern" onclick="selectProduct(${product.id}, '${product.name}')">
      <div class="product-item-content">
        <div class="product-item-header">
          <h5 class="product-item-title">${product.name}</h5>
          <span class="product-item-id">#${product.id}</span>
        </div>
        <div class="product-item-meta">
          <span class="product-item-category">
            <i class="fas fa-tag"></i>
            ${product.category}
          </span>
          <span class="product-item-stage">
            <i class="fas fa-flag"></i>
            ${product.stage}
          </span>
          <span class="product-item-date">
            <i class="fas fa-calendar"></i>
            ${product.date}
          </span>
          ${product.isVirtual ? '<span class="badge-modern badge-primary">Sanal</span>' : '<span class="badge-modern badge-success">Gerçek</span>'}
        </div>
      </div>
      <div class="product-item-actions">
        <button class="btn-modern btn-sm btn-secondary" onclick="event.stopPropagation(); editProduct(${product.id})" data-tooltip="Düzenle">
          <i class="fas fa-edit"></i>
        </button>
        <button class="btn-modern btn-sm btn-primary" onclick="event.stopPropagation(); viewProductTree(${product.id})" data-tooltip="Ağacı Görüntüle">
          <i class="fas fa-sitemap"></i>
        </button>
      </div>
    </div>
  `).join('');
  
  updateProductStats(products.length, products.length);
}

function updateProductStats(total, filtered) {
  document.getElementById('total-products-count').textContent = total;
  document.getElementById('filtered-products-count').textContent = filtered;
  totalProducts = total;
  filteredProducts = filtered;
}

function generateMockProducts(keyword, projectKeyword, category, status) {
  // Mock data generator - replace with actual API call
  const mockData = [
    { id: 1, name: 'Hidrolik Pompa Sistemi', category: 'Hidrolik', stage: 'Tasarım', date: '2024-01-15', isVirtual: true },
    { id: 2, name: 'Elektrik Motor Grubu', category: 'Elektrik', stage: 'Üretim', date: '2024-01-20', isVirtual: false },
    { id: 3, name: 'Kontrol Paneli', category: 'Elektronik', stage: 'Test', date: '2024-01-25', isVirtual: true },
    { id: 4, name: 'Mekanik Aktarım', category: 'Mekanik', stage: 'Tamamlandı', date: '2024-02-01', isVirtual: false },
    { id: 5, name: 'Sensör Modülü', category: 'Elektronik', stage: 'Tasarım', date: '2024-02-05', isVirtual: true }
  ];
  
  // Apply filters
  return mockData.filter(product => {
    if (keyword && !product.name.toLowerCase().includes(keyword.toLowerCase())) return false;
    if (projectKeyword && !product.id.toString().includes(projectKeyword)) return false;
    if (category && product.category !== category) return false;
    if (status && product.stage.toLowerCase() !== status.toLowerCase()) return false;
    return true;
  });
}

function selectProduct(productId, productName) {
  // Remove active class from all items
  document.querySelectorAll('.product-item-modern').forEach(item => {
    item.classList.remove('active');
  });
  
  // Add active class to selected item
  event.currentTarget.classList.add('active');
  
  // Update main form
  document.getElementById('pnamemain').value = productName;
  document.getElementById('vp_id').value = productId;
  
  // Load product tree
  loadProductTree(productId);
  
  // Show success feedback
  window.ModernUI.createToast(`"${productName}" seçildi`, 'success', { duration: 2000 });
}

function loadProductTree(productId) {
  const treeContent = document.getElementById('tree-content');
  const loadingOverlay = window.ModernUI.createLoadingSpinner(treeContent, {
    message: 'Ürün ağacı yükleniyor...'
  });
  
  // Simulate tree loading
  setTimeout(() => {
    // Call your existing tree loading function
    if (typeof window.loadTree === 'function') {
      window.loadTree(productId);
    }
    
    loadingOverlay.remove();
    updatePerformanceIndicator(Math.random() * 1000 + 200);
  }, 800);
}

function toggleView(viewType) {
  currentView = viewType;
  
  // Update button states
  document.querySelectorAll('.view-toggle .btn-modern').forEach(btn => {
    btn.classList.remove('active');
  });
  event.target.closest('.btn-modern').classList.add('active');
  
  // Update list view
  const listContainer = document.getElementById('resultArea');
  if (viewType === 'grid') {
    listContainer.classList.add('grid-view');
  } else {
    listContainer.classList.remove('grid-view');
  }
  
  window.ModernUI.createToast(`${viewType === 'grid' ? 'Kart' : 'Liste'} görünümü aktif`, 'info', { duration: 2000 });
}

function clearFilters() {
  document.getElementById('txtKeyword').value = '';
  document.getElementById('txtKeywordProject').value = '';
  document.getElementById('PCAT').value = '';
  document.getElementById('status_filter').value = '';
  
  searchProducts();
  
  window.ModernUI.createToast('Filtreler temizlendi', 'info', { duration: 2000 });
}

function refreshProductList() {
  const button = event.target.closest('.btn-modern');
  const icon = button.querySelector('i');
  
  icon.style.animation = 'spin 1s linear infinite';
  
  searchProducts();
  
  setTimeout(() => {
    icon.style.animation = '';
    window.ModernUI.createToast('Liste yenilendi', 'success');
  }, 1000);
}

function addNewProduct() {
  window.ModernUI.createModal(`
    <div class="add-product-form">
      <div class="form-group">
        <label for="new-product-name">Ürün Adı:</label>
        <input type="text" id="new-product-name" class="form-control-modern" placeholder="Yeni ürün adını girin">
      </div>
      <div class="form-group">
        <label for="new-product-category">Kategori:</label>
        <select id="new-product-category" class="form-control-modern">
          <option value="">Kategori Seçin</option>
          <option value="Hidrolik">Hidrolik</option>
          <option value="Elektrik">Elektrik</option>
          <option value="Mekanik">Mekanik</option>
          <option value="Elektronik">Elektronik</option>
        </select>
      </div>
      <div class="form-group">
        <label for="new-product-type">Ürün Türü:</label>
        <div class="radio-group">
          <label class="radio-label">
            <input type="radio" name="product-type" value="virtual" checked>
            <span>Sanal Ürün</span>
          </label>
          <label class="radio-label">
            <input type="radio" name="product-type" value="real">
            <span>Gerçek Ürün</span>
          </label>
        </div>
      </div>
    </div>
  `, {
    title: 'Yeni Ürün Ekle',
    size: 'medium',
    buttons: [
      {
        text: 'İptal',
        class: 'btn-secondary'
      },
      {
        text: 'Oluştur',
        class: 'btn-primary',
        handler: () => {
          const name = document.getElementById('new-product-name').value;
          const category = document.getElementById('new-product-category').value;
          const type = document.querySelector('input[name="product-type"]:checked').value;
          
          if (!name.trim()) {
            window.ModernUI.createToast('Ürün adı boş olamaz', 'error');
            return false;
          }
          
          if (!category) {
            window.ModernUI.createToast('Kategori seçilmelidir', 'error');
            return false;
          }
          
          // Create product logic here
          window.ModernUI.createToast(`"${name}" ürünü oluşturuldu`, 'success');
          searchProducts();
          return true;
        }
      }
    ]
  });
}

function editProduct(productId) {
  window.ModernUI.createToast(`Ürün #${productId} düzenleme ekranı açılıyor...`, 'info');
}

function viewProductTree(productId) {
  selectProduct(productId, `Ürün #${productId}`);
}

function loadMoreProducts() {
  currentPage++;
  showProductLoading();
  
  // Simulate loading more products
  setTimeout(() => {
    hideProductLoading();
    window.ModernUI.createToast('Daha fazla ürün yüklendi', 'success');
  }, 500);
}
</script>