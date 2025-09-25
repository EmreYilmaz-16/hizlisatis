<!--- 
CSP Violations Monitor - Development Tool
This page shows recent Content Security Policy violations for debugging
--->

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSP Violations Monitor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .violation-card {
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
        }
        .violation-header {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .code-block {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            overflow-x: auto;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-danger text-white">
                    <h4><i class="fas fa-shield-alt"></i> Content Security Policy Violations Monitor</h4>
                    <small>Development debugging tool - Remove in production</small>
                </div>
                <div class="card-body">
                    
                    <cfif structKeyExists(application, "cspViolations") AND arrayLen(application.cspViolations) GT 0>
                        
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Total Violations:</strong> <cfoutput>#arrayLen(application.cspViolations)#</cfoutput>
                            <small class="float-right">
                                <a href="?action=clear" class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash"></i> Clear All
                                </a>
                            </small>
                        </div>
                        
                        <cfif structKeyExists(url, "action") AND url.action EQ "clear">
                            <cfset application.cspViolations = []>
                            <div class="alert alert-success">
                                <i class="fas fa-check"></i> All violations cleared!
                            </div>
                            <cfset arrayLen = 0>
                        <cfelse>
                            <cfset arrayLen = arrayLen(application.cspViolations)>
                        </cfif>
                        
                        <cfif arrayLen GT 0>
                            <cfloop from="#arrayLen#" to="1" step="-1" index="i">
                                <cfset violation = application.cspViolations[i]>
                                <div class="card violation-card">
                                    <div class="card-header violation-header">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <i class="fas fa-exclamation-circle text-danger"></i>
                                                <strong>Violated Directive:</strong> <cfoutput>#violation.violated_directive#</cfoutput>
                                            </div>
                                            <div class="col-md-4 text-right">
                                                <small class="text-muted">
                                                    <i class="fas fa-clock"></i> <cfoutput>#violation.timestamp#</cfoutput>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong>Blocked URI:</strong><br>
                                                <div class="code-block"><cfoutput>#violation.blocked_uri#</cfoutput></div>
                                            </div>
                                            <div class="col-md-6">
                                                <strong>Source File:</strong><br>
                                                <div class="code-block"><cfoutput>#violation.source_file#</cfoutput></div>
                                                <cfif len(violation.line_number)>
                                                    <small><strong>Line:</strong> <cfoutput>#violation.line_number#</cfoutput></small>
                                                </cfif>
                                            </div>
                                        </div>
                                        
                                        <cfif len(violation.document_uri)>
                                            <div class="mt-2">
                                                <strong>Document URI:</strong><br>
                                                <div class="code-block"><cfoutput>#violation.document_uri#</cfoutput></div>
                                            </div>
                                        </cfif>
                                        
                                        <div class="mt-2">
                                            <small class="text-muted">
                                                <strong>IP:</strong> <cfoutput>#violation.ip_address#</cfoutput> |
                                                <strong>User Agent:</strong> <cfoutput>#left(violation.user_agent, 100)#</cfoutput><cfif len(violation.user_agent) GT 100>...</cfif>
                                            </small>
                                        </div>
                                        
                                        <cfif len(violation.original_policy)>
                                            <details class="mt-2">
                                                <summary class="text-info" style="cursor: pointer;">
                                                    <i class="fas fa-cog"></i> Show Original Policy
                                                </summary>
                                                <div class="code-block mt-2"><cfoutput>#violation.original_policy#</cfoutput></div>
                                            </details>
                                        </cfif>
                                    </div>
                                </div>
                            </cfloop>
                        </cfif>
                        
                    <cfelse>
                        
                        <div class="alert alert-success text-center">
                            <i class="fas fa-check-circle fa-3x mb-3"></i>
                            <h5>No CSP Violations Detected</h5>
                            <p class="mb-0">Your Content Security Policy is working correctly!</p>
                        </div>
                        
                    </cfif>
                    
                    <div class="mt-4">
                        <div class="card bg-light">
                            <div class="card-header">
                                <h6><i class="fas fa-info-circle"></i> About CSP Violations</h6>
                            </div>
                            <div class="card-body">
                                <p><strong>Common violation types:</strong></p>
                                <ul>
                                    <li><code>script-src</code> - Blocked JavaScript execution (often eval, inline scripts)</li>
                                    <li><code>style-src</code> - Blocked CSS styles (inline styles, external stylesheets)</li>
                                    <li><code>img-src</code> - Blocked image loading from unauthorized sources</li>
                                    <li><code>connect-src</code> - Blocked AJAX/fetch requests</li>
                                </ul>
                                <p><strong>To fix:</strong> Either update your CSP policy or remove the violating code.</p>
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <strong>Security Note:</strong> This monitoring page should be removed or secured in production environments.
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-3">
                        <a href="javascript:location.reload()" class="btn btn-primary">
                            <i class="fas fa-sync"></i> Refresh
                        </a>
                        <a href="../form/product_design.cfm" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Product Design
                        </a>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>