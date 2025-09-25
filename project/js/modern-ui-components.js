/**
 * Modern UI Components for Product Tree
 * Advanced animations, interactions, and responsive behaviors
 */

class ModernUIComponents {
    constructor() {
        this.components = new Map();
        this.animations = new Map();
        this.observers = new Map();
        this.init();
    }

    init() {
        this.setupIntersectionObserver();
        this.setupResizeObserver();
        this.setupMutationObserver();
        this.bindGlobalEvents();
    }

    // Animation System
    createAnimation(element, keyframes, options = {}) {
        const defaultOptions = {
            duration: 250,
            easing: 'cubic-bezier(0.4, 0, 0.2, 1)',
            fill: 'forwards'
        };

        const animation = element.animate(keyframes, { ...defaultOptions, ...options });
        const animationId = `anim_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        this.animations.set(animationId, animation);

        animation.addEventListener('finish', () => {
            this.animations.delete(animationId);
        });

        return animation;
    }

    // Enhanced Loading Component
    createLoadingSpinner(container, options = {}) {
        const defaults = {
            size: 'medium',
            color: 'primary',
            overlay: true,
            message: 'Yükleniyor...'
        };

        const config = { ...defaults, ...options };
        const loadingId = `loading_${Date.now()}`;

        const loadingHTML = `
            <div class="loading-overlay" data-loading-id="${loadingId}">
                <div class="loading-content">
                    <div class="loading-spinner loading-spinner-${config.size} loading-spinner-${config.color}"></div>
                    ${config.message ? `<div class="loading-message">${config.message}</div>` : ''}
                </div>
            </div>
        `;

        if (config.overlay) {
            container.style.position = 'relative';
        }

        container.insertAdjacentHTML('beforeend', loadingHTML);

        const loadingElement = container.querySelector(`[data-loading-id="${loadingId}"]`);
        
        // Fade in animation
        this.createAnimation(loadingElement, [
            { opacity: 0 },
            { opacity: 1 }
        ], { duration: 200 });

        return {
            id: loadingId,
            element: loadingElement,
            remove: () => this.removeLoading(loadingId, container)
        };
    }

    removeLoading(loadingId, container) {
        const loadingElement = container.querySelector(`[data-loading-id="${loadingId}"]`);
        if (loadingElement) {
            const fadeOut = this.createAnimation(loadingElement, [
                { opacity: 1 },
                { opacity: 0 }
            ], { duration: 200 });

            fadeOut.addEventListener('finish', () => {
                loadingElement.remove();
            });
        }
    }

    // Modern Toast Notification System
    createToast(message, type = 'info', options = {}) {
        const defaults = {
            duration: 5000,
            closable: true,
            actions: [],
            position: 'top-right'
        };

        const config = { ...defaults, ...options };
        const toastId = `toast_${Date.now()}`;

        // Ensure toast container exists
        let container = document.querySelector('.toast-container-modern');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container-modern';
            document.body.appendChild(container);
        }

        const toastHTML = `
            <div class="toast-modern toast-${type}" data-toast-id="${toastId}">
                <div class="toast-header">
                    <div class="toast-title">
                        <i class="toast-icon fas ${this.getToastIcon(type)}"></i>
                        <span>${this.getToastTitle(type)}</span>
                    </div>
                    ${config.closable ? '<button class="toast-close" aria-label="Kapat"><i class="fas fa-times"></i></button>' : ''}
                </div>
                <div class="toast-body">
                    <div class="toast-message">${message}</div>
                    ${config.actions.length > 0 ? this.renderToastActions(config.actions) : ''}
                </div>
                <div class="toast-progress">
                    <div class="toast-progress-bar"></div>
                </div>
            </div>
        `;

        container.insertAdjacentHTML('beforeend', toastHTML);
        const toastElement = container.querySelector(`[data-toast-id="${toastId}"]`);

        // Setup close functionality
        if (config.closable) {
            const closeBtn = toastElement.querySelector('.toast-close');
            closeBtn.addEventListener('click', () => this.removeToast(toastId));
        }

        // Setup action buttons
        config.actions.forEach((action, index) => {
            const actionBtn = toastElement.querySelector(`[data-action="${index}"]`);
            if (actionBtn && action.handler) {
                actionBtn.addEventListener('click', () => {
                    action.handler();
                    if (action.closeOnClick !== false) {
                        this.removeToast(toastId);
                    }
                });
            }
        });

        // Auto remove
        if (config.duration > 0) {
            const progressBar = toastElement.querySelector('.toast-progress-bar');
            if (progressBar) {
                this.createAnimation(progressBar, [
                    { transform: 'scaleX(1)' },
                    { transform: 'scaleX(0)' }
                ], { 
                    duration: config.duration,
                    easing: 'linear'
                });
            }

            setTimeout(() => {
                this.removeToast(toastId);
            }, config.duration);
        }

        return {
            id: toastId,
            element: toastElement,
            remove: () => this.removeToast(toastId)
        };
    }

    getToastIcon(type) {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        return icons[type] || icons.info;
    }

    getToastTitle(type) {
        const titles = {
            success: 'Başarılı',
            error: 'Hata',
            warning: 'Uyarı',
            info: 'Bilgi'
        };
        return titles[type] || titles.info;
    }

    renderToastActions(actions) {
        return `
            <div class="toast-actions">
                ${actions.map((action, index) => `
                    <button class="btn-modern btn-sm ${action.class || 'btn-secondary'}" data-action="${index}">
                        ${action.text}
                    </button>
                `).join('')}
            </div>
        `;
    }

    removeToast(toastId) {
        const toastElement = document.querySelector(`[data-toast-id="${toastId}"]`);
        if (toastElement) {
            const slideOut = this.createAnimation(toastElement, [
                { transform: 'translateX(0)', opacity: 1 },
                { transform: 'translateX(100%)', opacity: 0 }
            ], { duration: 300 });

            slideOut.addEventListener('finish', () => {
                toastElement.remove();
            });
        }
    }

    // Enhanced Modal System
    createModal(content, options = {}) {
        const defaults = {
            title: '',
            size: 'medium',
            closable: true,
            backdrop: true,
            centered: true,
            animation: 'fade',
            buttons: []
        };

        const config = { ...defaults, ...options };
        const modalId = `modal_${Date.now()}`;

        const modalHTML = `
            <div class="modal-backdrop-modern" data-modal-id="${modalId}">
                <div class="modal-dialog-modern modal-${config.size} ${config.centered ? 'modal-centered' : ''}">
                    <div class="modal-content-modern">
                        ${config.title ? `
                            <div class="modal-header-modern">
                                <h5 class="modal-title-modern">${config.title}</h5>
                                ${config.closable ? '<button class="modal-close-modern"><i class="fas fa-times"></i></button>' : ''}
                            </div>
                        ` : ''}
                        <div class="modal-body-modern">
                            ${content}
                        </div>
                        ${config.buttons.length > 0 ? `
                            <div class="modal-footer-modern">
                                ${config.buttons.map((btn, index) => `
                                    <button class="btn-modern ${btn.class || 'btn-secondary'}" data-modal-action="${index}">
                                        ${btn.text}
                                    </button>
                                `).join('')}
                            </div>
                        ` : ''}
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);
        const modalElement = document.querySelector(`[data-modal-id="${modalId}"]`);

        // Prevent body scroll
        document.body.style.overflow = 'hidden';

        // Setup close functionality
        if (config.closable) {
            const closeBtn = modalElement.querySelector('.modal-close-modern');
            if (closeBtn) {
                closeBtn.addEventListener('click', () => this.removeModal(modalId));
            }
        }

        if (config.backdrop) {
            modalElement.addEventListener('click', (e) => {
                if (e.target === modalElement) {
                    this.removeModal(modalId);
                }
            });
        }

        // Setup button actions
        config.buttons.forEach((button, index) => {
            const actionBtn = modalElement.querySelector(`[data-modal-action="${index}"]`);
            if (actionBtn && button.handler) {
                actionBtn.addEventListener('click', () => {
                    const result = button.handler();
                    if (result !== false && button.closeOnClick !== false) {
                        this.removeModal(modalId);
                    }
                });
            }
        });

        // Show animation
        this.createAnimation(modalElement, [
            { opacity: 0 },
            { opacity: 1 }
        ], { duration: 200 });

        const dialog = modalElement.querySelector('.modal-dialog-modern');
        this.createAnimation(dialog, [
            { transform: 'scale(0.8) translateY(-20px)', opacity: 0 },
            { transform: 'scale(1) translateY(0)', opacity: 1 }
        ], { duration: 300, easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)' });

        return {
            id: modalId,
            element: modalElement,
            remove: () => this.removeModal(modalId)
        };
    }

    removeModal(modalId) {
        const modalElement = document.querySelector(`[data-modal-id="${modalId}"]`);
        if (modalElement) {
            const dialog = modalElement.querySelector('.modal-dialog-modern');
            
            const hideDialogAnimation = this.createAnimation(dialog, [
                { transform: 'scale(1) translateY(0)', opacity: 1 },
                { transform: 'scale(0.8) translateY(-20px)', opacity: 0 }
            ], { duration: 200 });

            const hideBackdropAnimation = this.createAnimation(modalElement, [
                { opacity: 1 },
                { opacity: 0 }
            ], { duration: 300 });

            hideBackdropAnimation.addEventListener('finish', () => {
                modalElement.remove();
                document.body.style.overflow = '';
            });
        }
    }

    // Enhanced Skeleton Loading
    createSkeletonLoader(container, config = {}) {
        const defaults = {
            rows: 3,
            columns: 1,
            height: '20px',
            borderRadius: '4px',
            spacing: '12px'
        };

        const settings = { ...defaults, ...config };
        const skeletonId = `skeleton_${Date.now()}`;

        const skeletonHTML = `
            <div class="skeleton-container" data-skeleton-id="${skeletonId}">
                ${Array.from({ length: settings.rows }, (_, rowIndex) => `
                    <div class="skeleton-row" style="margin-bottom: ${settings.spacing}">
                        ${Array.from({ length: settings.columns }, (_, colIndex) => `
                            <div class="loading-skeleton" style="
                                height: ${settings.height};
                                border-radius: ${settings.borderRadius};
                                ${settings.columns > 1 ? `width: ${100 / settings.columns}%; margin-right: ${settings.spacing};` : ''}
                            "></div>
                        `).join('')}
                    </div>
                `).join('')}
            </div>
        `;

        container.insertAdjacentHTML('beforeend', skeletonHTML);

        return {
            id: skeletonId,
            remove: () => {
                const skeleton = container.querySelector(`[data-skeleton-id="${skeletonId}"]`);
                if (skeleton) skeleton.remove();
            }
        };
    }

    // Progressive Image Loading
    setupProgressiveImages() {
        const images = document.querySelectorAll('img[data-src]');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    }
                });
            });

            images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback for older browsers
            images.forEach(img => {
                img.src = img.dataset.src;
                img.classList.add('loaded');
            });
        }
    }

    // Smooth Scrolling Utility
    smoothScrollTo(target, options = {}) {
        const defaults = {
            duration: 500,
            easing: 'ease-in-out',
            offset: 0
        };

        const config = { ...defaults, ...options };
        const targetElement = typeof target === 'string' ? document.querySelector(target) : target;
        
        if (!targetElement) return;

        const targetPosition = targetElement.offsetTop - config.offset;
        const startPosition = window.pageYOffset;
        const distance = targetPosition - startPosition;
        let startTime = null;

        function animation(currentTime) {
            if (startTime === null) startTime = currentTime;
            const timeElapsed = currentTime - startTime;
            const progress = Math.min(timeElapsed / config.duration, 1);

            const ease = {
                'ease-in-out': t => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t,
                'ease-in': t => t * t,
                'ease-out': t => t * (2 - t),
                'linear': t => t
            };

            const easedProgress = ease[config.easing] ? ease[config.easing](progress) : progress;
            window.scrollTo(0, startPosition + distance * easedProgress);

            if (timeElapsed < config.duration) {
                requestAnimationFrame(animation);
            }
        }

        requestAnimationFrame(animation);
    }

    // Observer Setup
    setupIntersectionObserver() {
        if ('IntersectionObserver' in window) {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('in-view');
                        this.triggerCustomEvent(entry.target, 'elementInView', {
                            element: entry.target,
                            intersectionRatio: entry.intersectionRatio
                        });
                    }
                });
            }, {
                threshold: 0.1,
                rootMargin: '50px'
            });

            this.observers.set('intersection', observer);
        }
    }

    setupResizeObserver() {
        if ('ResizeObserver' in window) {
            const observer = new ResizeObserver((entries) => {
                entries.forEach(entry => {
                    this.triggerCustomEvent(entry.target, 'elementResize', {
                        element: entry.target,
                        contentRect: entry.contentRect
                    });
                });
            });

            this.observers.set('resize', observer);
        }
    }

    setupMutationObserver() {
        const observer = new MutationObserver((mutations) => {
            mutations.forEach(mutation => {
                if (mutation.type === 'childList') {
                    mutation.addedNodes.forEach(node => {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            this.initializeNewElements(node);
                        }
                    });
                }
            });
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        this.observers.set('mutation', observer);
    }

    initializeNewElements(element) {
        // Initialize progressive images
        const lazyImages = element.querySelectorAll ? element.querySelectorAll('img[data-src]') : [];
        lazyImages.forEach(img => {
            if (this.observers.has('intersection')) {
                this.observers.get('intersection').observe(img);
            }
        });

        // Initialize tooltips
        const tooltipElements = element.querySelectorAll ? element.querySelectorAll('[data-tooltip]') : [];
        tooltipElements.forEach(el => this.initializeTooltip(el));
    }

    initializeTooltip(element) {
        element.addEventListener('mouseenter', (e) => {
            this.showTooltip(e.target, e.target.dataset.tooltip);
        });

        element.addEventListener('mouseleave', () => {
            this.hideTooltip();
        });
    }

    showTooltip(element, text) {
        const tooltip = document.createElement('div');
        tooltip.className = 'tooltip-modern';
        tooltip.textContent = text;
        tooltip.id = 'active-tooltip';
        
        document.body.appendChild(tooltip);

        const rect = element.getBoundingClientRect();
        tooltip.style.left = `${rect.left + rect.width / 2}px`;
        tooltip.style.top = `${rect.top - tooltip.offsetHeight - 8}px`;

        this.createAnimation(tooltip, [
            { opacity: 0, transform: 'translateY(10px)' },
            { opacity: 1, transform: 'translateY(0)' }
        ], { duration: 200 });
    }

    hideTooltip() {
        const tooltip = document.getElementById('active-tooltip');
        if (tooltip) {
            const fadeOut = this.createAnimation(tooltip, [
                { opacity: 1 },
                { opacity: 0 }
            ], { duration: 150 });

            fadeOut.addEventListener('finish', () => {
                tooltip.remove();
            });
        }
    }

    // Global Event Bindings
    bindGlobalEvents() {
        // ESC key to close modals
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                const activeModal = document.querySelector('.modal-backdrop-modern');
                if (activeModal) {
                    const modalId = activeModal.dataset.modalId;
                    this.removeModal(modalId);
                }
            }
        });

        // Click outside to close dropdowns
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.dropdown-modern')) {
                document.querySelectorAll('.dropdown-modern.open').forEach(dropdown => {
                    dropdown.classList.remove('open');
                });
            }
        });
    }

    // Custom Event Trigger
    triggerCustomEvent(element, eventName, detail = {}) {
        const event = new CustomEvent(eventName, {
            detail,
            bubbles: true,
            cancelable: true
        });
        element.dispatchEvent(event);
    }

    // Utility Methods
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }

    // Cleanup
    destroy() {
        this.observers.forEach(observer => observer.disconnect());
        this.animations.forEach(animation => animation.cancel());
        this.components.clear();
        this.animations.clear();
        this.observers.clear();
    }
}

// Export for global use
window.ModernUI = new ModernUIComponents();

// Initialize on DOM ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.ModernUI.setupProgressiveImages();
    });
} else {
    window.ModernUI.setupProgressiveImages();
}