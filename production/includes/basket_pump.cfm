
<style>
    .pbsContex {
    position: fixed;
    z-index: 99999;
    width: 150px;
    height: 150px;
    box-shadow: 4px 5px #8080806b;

    background: #d9d9d9c7;
    border-radius: 0px 0 30px 0;
}
.list-group {
    --bs-list-group-color: #212529;
    --bs-list-group-bg: #fff;
    --bs-list-group-border-color: rgba(0, 0, 0, 0.125);
    --bs-list-group-border-width: 1px;
    --bs-list-group-border-radius: 0.375rem;
    --bs-list-group-item-padding-x: 1rem;
    --bs-list-group-item-padding-y: 0.5rem;
    --bs-list-group-action-color: #495057;
    --bs-list-group-action-hover-color: #495057;
    --bs-list-group-action-hover-bg: #f8f9fa;
    --bs-list-group-action-active-color: #212529;
    --bs-list-group-action-active-bg: #e9ecef;
    --bs-list-group-disabled-color: #6c757d;
    --bs-list-group-disabled-bg: #fff;
    --bs-list-group-active-color: #fff;
    --bs-list-group-active-bg: #0d6efd;
    --bs-list-group-active-border-color: #0d6efd;
    display: flex;
    flex-direction: column;
    padding-left: 0;
    margin-bottom: 0;
    margin-left: 5px;
    border-radius: var(--bs-list-group-border-radius);
}

.list-group-item+.list-group-item {
    border-top-width: 0;
}

.list-group-item {
    position: relative;
    display: block;
    padding: var(--bs-list-group-item-padding-y) var(--bs-list-group-item-padding-x);
    color: var(--bs-list-group-color);
    text-decoration: none;
    background-color: var(--bs-list-group-bg);
    border: var(--bs-list-group-border-width) solid var(--bs-list-group-border-color);
}

.list-group-item-action {
    width: 100%;
    color: var(--bs-list-group-action-color);
    text-align: inherit;
}

.list-group-item-light {
    color: #636464;
    background-color: #fefefe;
}

.list-group-item-warning {
    color: #664d03;
    background-color: #fff3cd;
}

.list-group-item-secondary {
    color: #41464b;
    background-color: #e2e3e5;
}
</style>
<cf_box title="Pompa Üretim Emri">
<div id="SepetDiv" class="row">

</div>

</cf_box>

<script src="/AddOns/Partner/production/js/pump.js"></script>