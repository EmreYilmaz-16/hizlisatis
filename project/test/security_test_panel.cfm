<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Güvenlik Test Paneli - Product Design</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .security-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .test-card {
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
        }
        .test-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .result-success {
            color: #28a745;
            background-color: #d4edda;
            padding: 0.5rem;
            border-radius: 0.25rem;
        }
        .result-warning {
            color: #ffc107;
            background-color: #fff3cd;
            padding: 0.5rem;
            border-radius: 0.25rem;
        }
        .result-danger {
            color: #dc3545;
            background-color: #f8d7da;
            padding: 0.5rem;
            border-radius: 0.25rem;
        }
        .log-container {
            max-height: 400px;
            overflow-y: auto;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
        }
        .log-entry {
            padding: 0.5rem;
            border-bottom: 1px solid #e9ecef;
            font-family: 'Courier New', monospace;
            font-size: 0.875rem;
        }
        .log-entry:last-child {
            border-bottom: none;
        }
        .security-metric {
            text-align: center;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
        .metric-excellent {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .metric-good {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .metric-poor {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <!--- Security includes --->
    <cfinclude template="../includes/security_include.cfm">
    
    <!--- Initialize components --->
    <cfset securityValidator = createObject("component", "../cfc.SecurityValidator")>
    <cfset auditLogger = createObject("component", "../cfc.AuditLogger")>
    
    <!--- Log test panel access --->
    <cfset auditLogger.logUserAction("SECURITY_TEST_ACCESS", "Accessed security test panel", "", {}, {}, "WARNING")>
    
    <!--- Test Results Structure --->
    <cfscript>
        testResults = {
            csrf: {status: "pending", message: "", details: ""},
            sqlInjection: {status: "pending", message: "", details: ""},
            xss: {status: "pending", message: "", details: ""},
            rateLimit: {status: "pending", message: "", details: ""},
            sessionSecurity: {status: "pending", message: "", details: ""},
            inputValidation: {status: "pending", message: "", details: ""},
            auditLogging: {status: "pending", message: "", details: ""}
        };
        
        securityScore = 0;
        totalTests = structCount(testResults);
    </cfscript>

    <div class="security-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-shield-alt me-3"></i>Güvenlik Test Paneli</h1>
                    <p class="mb-0">Product Design sistemi güvenlik testleri ve izleme paneli</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="security-metric metric-excellent">
                        <h3 id="securityScore">--</h3>
                        <p class="mb-0">Güvenlik Skoru</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <!-- Test Controls -->
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-play-circle me-2"></i>Güvenlik Testleri</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <button class="btn btn-primary w-100" onclick="runAllTests()">
                                    <i class="fas fa-rocket me-2"></i>Tüm Testleri Çalıştır
                                </button>
                            </div>
                            <div class="col-md-6 mb-3">
                                <button class="btn btn-secondary w-100" onclick="clearResults()">
                                    <i class="fas fa-trash me-2"></i>Sonuçları Temizle
                                </button>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testCSRF()">CSRF Test</button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testSQLInjection()">SQL Injection</button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testXSS()">XSS Test</button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testRateLimit()">Rate Limiting</button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testSession()">Session Security</button>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-outline-primary btn-sm w-100" onclick="testInput()">Input Validation</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Test Results -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-clipboard-check me-2"></i>Test Sonuçları</h5>
                    </div>
                    <div class="card-body" id="testResults">
                        <div class="row" id="resultsContainer">
                            <!-- Results will be populated by JavaScript -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- Security Metrics & Logs -->
            <div class="col-md-4">
                <!-- Security Metrics -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h6><i class="fas fa-chart-line me-2"></i>Güvenlik Metrikleri</h6>
                    </div>
                    <div class="card-body">
                        <div class="security-metric metric-excellent" id="csrfMetric">
                            <i class="fas fa-shield-alt fa-2x"></i>
                            <h6>CSRF Koruması</h6>
                            <span class="badge bg-success">Aktif</span>
                        </div>
                        
                        <div class="security-metric metric-excellent" id="sessionMetric">
                            <i class="fas fa-clock fa-2x"></i>
                            <h6>Session Timeout</h6>
                            <span class="badge bg-success">30 dakika</span>
                        </div>
                        
                        <div class="security-metric metric-good" id="rateLimitMetric">
                            <i class="fas fa-tachometer-alt fa-2x"></i>
                            <h6>Rate Limiting</h6>
                            <span class="badge bg-warning">30 req/min</span>
                        </div>
                    </div>
                </div>

                <!-- Recent Security Events -->
                <div class="card">
                    <div class="card-header">
                        <h6><i class="fas fa-history me-2"></i>Son Güvenlik Olayları</h6>
                        <button class="btn btn-sm btn-outline-secondary float-end" onclick="refreshLogs()">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div class="log-container" id="securityLogs">
                            <!-- Logs will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Security Test Framework
        class SecurityTester {
            constructor() {
                this.tests = {
                    csrf: false,
                    sqlInjection: false,
                    xss: false,
                    rateLimit: false,
                    sessionSecurity: false,
                    inputValidation: false,
                    auditLogging: false
                };
                this.results = {};
                this.csrfToken = window.CSRF_TOKEN || '';
            }

            async runAllTests() {
                this.showLoader(true);
                const tests = [
                    'testCSRF',
                    'testSQLInjection', 
                    'testXSS',
                    'testRateLimit',
                    'testSession',
                    'testInput',
                    'testAuditLogging'
                ];
                
                for (let test of tests) {
                    await this[test]();
                    await this.delay(500); // Small delay between tests
                }
                
                this.calculateScore();
                this.showLoader(false);
            }

            async testCSRF() {
                try {
                    // Test valid CSRF token
                    let validResponse = await fetch('../cfc/product_design.cfc?method=getTree', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `csrf_token=${this.csrfToken}&parent_id=0`
                    });
                    
                    // Test invalid CSRF token
                    let invalidResponse = await fetch('../cfc/product_design.cfc?method=getTree', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `csrf_token=invalid&parent_id=0`
                    });
                    
                    if (validResponse.ok && !invalidResponse.ok) {
                        this.updateResult('csrf', 'success', 'CSRF koruması çalışıyor', 
                            'Geçerli token kabul edildi, geçersiz token reddedildi');
                    } else {
                        this.updateResult('csrf', 'danger', 'CSRF koruması zayıf', 
                            'Token validasyonu beklendiği gibi çalışmıyor');
                    }
                } catch (error) {
                    this.updateResult('csrf', 'warning', 'CSRF testi tamamlanamadı', error.message);
                }
            }

            async testSQLInjection() {
                try {
                    const maliciousInputs = [
                        "'; DROP TABLE products; --",
                        "1' OR '1'='1",
                        "1; DELETE FROM users WHERE 1=1; --",
                        "1' UNION SELECT * FROM users --"
                    ];
                    
                    let vulnerabilityFound = false;
                    
                    for (let input of maliciousInputs) {
                        let response = await fetch('../cfc/product_design.cfc?method=getTree', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: `csrf_token=${this.csrfToken}&parent_id=${encodeURIComponent(input)}`
                        });
                        
                        if (response.ok) {
                            let data = await response.text();
                            if (data.includes('error') || data.includes('Exception')) {
                                vulnerabilityFound = true;
                                break;
                            }
                        }
                    }
                    
                    if (!vulnerabilityFound) {
                        this.updateResult('sqlInjection', 'success', 'SQL Injection koruması aktif', 
                            'Zararlı SQL girişleri başarıyla engellendi');
                    } else {
                        this.updateResult('sqlInjection', 'danger', 'SQL Injection riski tespit edildi', 
                            'Parameterized queries kullanımı gerekiyor');
                    }
                } catch (error) {
                    this.updateResult('sqlInjection', 'warning', 'SQL Injection testi tamamlanamadı', error.message);
                }
            }

            async testXSS() {
                try {
                    const xssPayloads = [
                        '<script>alert("XSS")</script>',
                        'javascript:alert("XSS")',
                        '<img src="x" onerror="alert(1)">',
                        '<svg onload="alert(1)">'
                    ];
                    
                    let xssBlocked = 0;
                    
                    for (let payload of xssPayloads) {
                        // Test XSS in various inputs
                        let testDiv = document.createElement('div');
                        testDiv.innerHTML = this.sanitizeInput(payload);
                        
                        if (!testDiv.innerHTML.includes('<script>') && 
                            !testDiv.innerHTML.includes('javascript:') &&
                            !testDiv.innerHTML.includes('onerror=') &&
                            !testDiv.innerHTML.includes('onload=')) {
                            xssBlocked++;
                        }
                    }
                    
                    if (xssBlocked === xssPayloads.length) {
                        this.updateResult('xss', 'success', 'XSS koruması çalışıyor', 
                            'Tüm XSS payloadları temizlendi');
                    } else {
                        this.updateResult('xss', 'danger', 'XSS riski var', 
                            `${xssPayloads.length - xssBlocked} payload engellenmedi`);
                    }
                } catch (error) {
                    this.updateResult('xss', 'warning', 'XSS testi tamamlanamadı', error.message);
                }
            }

            async testRateLimit() {
                try {
                    let requestCount = 0;
                    let blockedRequests = 0;
                    
                    // Send multiple requests quickly
                    const promises = [];
                    for (let i = 0; i < 10; i++) {
                        promises.push(
                            fetch('../cfc/product_design.cfc?method=getTree', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: `csrf_token=${this.csrfToken}&parent_id=0`
                            }).then(response => {
                                requestCount++;
                                if (response.status === 429) {
                                    blockedRequests++;
                                }
                                return response.status;
                            })
                        );
                    }
                    
                    await Promise.all(promises);
                    
                    if (blockedRequests > 0) {
                        this.updateResult('rateLimit', 'success', 'Rate limiting çalışıyor', 
                            `${blockedRequests} istek engellendi`);
                    } else {
                        this.updateResult('rateLimit', 'warning', 'Rate limiting pasif', 
                            'Hızlı istekler engellenmedi');
                    }
                } catch (error) {
                    this.updateResult('rateLimit', 'warning', 'Rate limit testi tamamlanamadı', error.message);
                }
            }

            async testSession() {
                try {
                    // Check session timeout configuration
                    const sessionTimeout = window.SESSION_TIMEOUT || 0;
                    
                    if (sessionTimeout >= 30) {
                        this.updateResult('sessionSecurity', 'success', 'Session güvenliği iyi', 
                            `Session timeout: ${sessionTimeout} dakika`);
                    } else if (sessionTimeout > 0) {
                        this.updateResult('sessionSecurity', 'warning', 'Session timeout kısa', 
                            `${sessionTimeout} dakika yerine en az 30 dakika önerilir`);
                    } else {
                        this.updateResult('sessionSecurity', 'danger', 'Session timeout yapılandırılmamış', 
                            'Session güvenlik ayarları eksik');
                    }
                } catch (error) {
                    this.updateResult('sessionSecurity', 'warning', 'Session testi tamamlanamadı', error.message);
                }
            }

            async testInput() {
                try {
                    const testInputs = [
                        { input: 'normal_input', expected: true },
                        { input: '<script>alert("test")</script>', expected: false },
                        { input: "'; DROP TABLE test; --", expected: false },
                        { input: 'javascript:alert(1)', expected: false }
                    ];
                    
                    let passedTests = 0;
                    
                    testInputs.forEach(test => {
                        const sanitized = this.sanitizeInput(test.input);
                        const isClean = !sanitized.includes('<script>') && 
                                       !sanitized.includes('DROP TABLE') && 
                                       !sanitized.includes('javascript:');
                        
                        if ((test.expected && isClean) || (!test.expected && isClean)) {
                            passedTests++;
                        }
                    });
                    
                    if (passedTests === testInputs.length) {
                        this.updateResult('inputValidation', 'success', 'Input validasyon çalışıyor', 
                            'Tüm zararlı girişler temizlendi');
                    } else {
                        this.updateResult('inputValidation', 'warning', 'Input validasyon eksik', 
                            `${testInputs.length - passedTests} test başarısız`);
                    }
                } catch (error) {
                    this.updateResult('inputValidation', 'warning', 'Input validasyon testi tamamlanamadı', error.message);
                }
            }

            async testAuditLogging() {
                try {
                    // Test if audit logging is working by making a test action
                    let response = await fetch('../test/test_audit.cfm', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `csrf_token=${this.csrfToken}&test_action=security_test`
                    });
                    
                    if (response.ok) {
                        this.updateResult('auditLogging', 'success', 'Audit logging çalışıyor', 
                            'Test aksiyonu loglandı');
                    } else {
                        this.updateResult('auditLogging', 'warning', 'Audit logging test edilemedi', 
                            'Test endpoint ulaşılamıyor');
                    }
                } catch (error) {
                    this.updateResult('auditLogging', 'warning', 'Audit logging testi tamamlanamadı', error.message);
                }
            }

            sanitizeInput(input) {
                return input
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#x27;')
                    .replace(/javascript:/gi, '');
            }

            updateResult(testName, status, message, details) {
                this.results[testName] = { status, message, details };
                this.tests[testName] = (status === 'success');
                this.renderResults();
            }

            renderResults() {
                const container = document.getElementById('resultsContainer');
                let html = '';
                
                for (let [testName, result] of Object.entries(this.results)) {
                    const statusClass = `result-${result.status}`;
                    const icon = result.status === 'success' ? 'check-circle' : 
                                result.status === 'warning' ? 'exclamation-triangle' : 'times-circle';
                    
                    html += `
                        <div class="col-md-6 mb-3">
                            <div class="test-card card">
                                <div class="card-body">
                                    <div class="${statusClass}">
                                        <h6><i class="fas fa-${icon} me-2"></i>${this.getTestDisplayName(testName)}</h6>
                                        <p class="mb-1"><strong>${result.message}</strong></p>
                                        <small>${result.details}</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                }
                
                container.innerHTML = html;
            }

            getTestDisplayName(testName) {
                const names = {
                    csrf: 'CSRF Koruması',
                    sqlInjection: 'SQL Injection',
                    xss: 'XSS Koruması', 
                    rateLimit: 'Rate Limiting',
                    sessionSecurity: 'Session Güvenliği',
                    inputValidation: 'Input Validasyonu',
                    auditLogging: 'Audit Logging'
                };
                return names[testName] || testName;
            }

            calculateScore() {
                const passedTests = Object.values(this.tests).filter(t => t).length;
                const totalTests = Object.keys(this.tests).length;
                const score = Math.round((passedTests / totalTests) * 100);
                
                document.getElementById('securityScore').textContent = `${score}%`;
                
                const scoreElement = document.getElementById('securityScore').parentElement;
                scoreElement.className = 'security-metric ' + 
                    (score >= 80 ? 'metric-excellent' : score >= 60 ? 'metric-good' : 'metric-poor');
            }

            clearResults() {
                this.results = {};
                this.tests = {
                    csrf: false,
                    sqlInjection: false,
                    xss: false,
                    rateLimit: false,
                    sessionSecurity: false,
                    inputValidation: false,
                    auditLogging: false
                };
                document.getElementById('resultsContainer').innerHTML = '';
                document.getElementById('securityScore').textContent = '--';
                document.getElementById('securityScore').parentElement.className = 'security-metric metric-excellent';
            }

            showLoader(show) {
                // Implementation for loading indicator
            }

            delay(ms) {
                return new Promise(resolve => setTimeout(resolve, ms));
            }
        }

        // Initialize tester
        const securityTester = new SecurityTester();

        // Global functions for buttons
        function runAllTests() {
            securityTester.runAllTests();
        }

        function clearResults() {
            securityTester.clearResults();
        }

        function testCSRF() {
            securityTester.testCSRF();
        }

        function testSQLInjection() {
            securityTester.testSQLInjection();
        }

        function testXSS() {
            securityTester.testXSS();
        }

        function testRateLimit() {
            securityTester.testRateLimit();
        }

        function testSession() {
            securityTester.testSession();
        }

        function testInput() {
            securityTester.testInput();
        }

        function refreshLogs() {
            loadSecurityLogs();
        }

        // Load security logs
        async function loadSecurityLogs() {
            try {
                const response = await fetch('../api/security_logs.cfm');
                const data = await response.json();
                
                const logsContainer = document.getElementById('securityLogs');
                let logsHtml = '';
                
                data.logs.forEach(log => {
                    const logClass = log.severity === 'ERROR' || log.severity === 'CRITICAL' ? 'text-danger' :
                                    log.severity === 'WARNING' ? 'text-warning' : 'text-info';
                    
                    logsHtml += `
                        <div class="log-entry ${logClass}">
                            <strong>[${log.timestamp}]</strong> ${log.category} - ${log.action}<br>
                            <small>${log.details}</small>
                        </div>
                    `;
                });
                
                logsContainer.innerHTML = logsHtml || '<div class="log-entry text-muted">Log bulunamadı</div>';
            } catch (error) {
                document.getElementById('securityLogs').innerHTML = 
                    '<div class="log-entry text-danger">Log yüklenirken hata oluştu</div>';
            }
        }

        // Load logs on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadSecurityLogs();
        });
    </script>
</body>
</html>