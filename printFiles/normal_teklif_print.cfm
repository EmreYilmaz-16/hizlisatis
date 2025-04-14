<cfquery name="qProductTree" datasource="#dsn3#">
    WITH ProductTreeCTE AS (
        SELECT 
            PT.STOCK_ID,
            PT.RELATED_ID,
            PT.PRICE_PBS,
            PT.DISCOUNT_PBS,
            PT.OTHER_MONEY_PBS,
            PT.AMOUNT,
            1 AS LEVEL
        FROM PRODUCT_TREE PT
        WHERE PT.STOCK_ID = 48335
    
        UNION ALL
    
        SELECT 
            PT.STOCK_ID,
            PT.RELATED_ID,
            PT.PRICE_PBS,
            PT.DISCOUNT_PBS,
            PT.OTHER_MONEY_PBS,
            PT.AMOUNT,
            CTE.LEVEL + 1
        FROM PRODUCT_TREE PT
        INNER JOIN ProductTreeCTE CTE ON PT.STOCK_ID = CTE.RELATED_ID
        WHERE CTE.LEVEL < 5
    )
    
    SELECT 
        T.STOCK_ID AS ParentID,
        T.RELATED_ID AS ID,
        S.PRODUCT_NAME,
        T.PRICE_PBS AS PRICE,
        T.OTHER_MONEY_PBS AS MONEY,
        T.DISCOUNT_PBS AS DISCOUNT,
        PB.BRAND_NAME,
        PU.MAIN_UNIT,
        T.LEVEL,
        T.AMOUNT
    FROM ProductTreeCTE T
    INNER JOIN STOCKS S ON S.STOCK_ID = T.RELATED_ID
    LEFT JOIN PRODUCT_BRANDS PB ON PB.BRAND_ID = S.BRAND_ID
    LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
    ORDER BY T.LEVEL, S.PRODUCT_NAME


    </cfquery>
<cfscript>
treeData = [];

for (row in qProductTree) {
    arrayAppend(treeData, {
        id: row.ID,
        parentId: row.ParentID,
        name: row.PRODUCT_NAME,
        price: row.PRICE,
        money: row.MONEY,
        brand: row.BRAND_NAME,
        unit: row.MAIN_UNIT,
        discount: row.DISCOUNT,
        level: row.LEVEL,
        amount: row.AMOUNT
    });
}

// Ağaç şeklinde renderlayan fonksiyon
function renderTree(data, parentId, depth = 0) {
    var html = "";
    serialNumber = 1; // sıra numarası için başlangıç
    for (item in data) {
        if (item.parentId == parentId) {
            var hasChildren = arrayLen(arrayFilter(data, function(el){ return el.parentId == item.id; }));
            html &= "<tr class='tree-row' data-id='#item.id#' data-parent='#parentId#' data-level='#depth#'>";
                html &= "<td>#serialNumber++#</td>"; // sıra numarası için önceden `serialNumber = 1` tanımlanmalı
                html &= "<td style='padding-left:#depth * 20#px'>";
                if (hasChildren > 0) {
                    html &= "<span class='toggle-icon' data-toggle='#item.id#' style='cursor:pointer;'>▶</span> ";
                } else {
                    html &= "<span style='visibility:hidden'>▶</span> ";
                }
                html &= "📦 " & item.name & "</td>";
                html &= "<td>" & item.brand & "</td>";
                html &= "<td>#tlformat(item.amount)#</td>"; // miktar sabit ya da dinamik
                html &= "<td>" & tlformat(item.price) & "</td>";
                html &= "<td>" & tlformat(item.price) & "</td>"; // toplam örnek olarak aynı
                html &= "<td>" & item.money & "</td>";
                html &= "<td>" & dateFormat(now(), "dd.mm.yyyy") & "</td>"; // teslim tarihi örnek
                html &= "</tr>";

            html &= renderTree(data, item.id, depth + 1);
        }
    }

    return html;
}

treeHtml = renderTree(treeData, 7542);
</cfscript>

<style>
table.treeview-table {
    width: 100%;
    border-collapse: collapse;
}

table.treeview-table th, table.treeview-table td {
    border: 1px solid #ccc;
    padding: 8px;
}

.tree-indent {
    padding-left: 20px;
}
</style>

    
<table class="product-table" style="margin-top: 10px; font-size: 12px;">
    <thead>
        <tr>
            <th>SN</th>
            <th>Malzeme Adı</th>
            <th>Marka</th>
            <th>Miktar</th>
            <th>Net Birim Fiyat</th>
            <th>Net Toplam Tutar</th>
            <th>Para Birimi</th>
            <th>Teslim Tarihi</th>
        </tr>
    </thead>
    <tbody id="tree-table-body">
        <cfoutput>#treeHtml#</cfoutput>
    </tbody>
</table>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const toggles = document.querySelectorAll('.toggle-icon');

        toggles.forEach(toggle => {
            toggle.addEventListener('click', function () {
                const id = this.getAttribute('data-toggle');
                const rows = document.querySelectorAll(`.tree-row[data-parent='${id}']`);
                const isOpen = this.textContent === '▼';

                this.textContent = isOpen ? '▶' : '▼';

                rows.forEach(row => {
                    if (isOpen) {
                        row.style.display = 'none';
                        collapseChildren(row.getAttribute('data-id')); // alt dalları da kapat
                    } else {
                        row.style.display = 'table-row';
                    }
                });
            });
        });

        // Alt seviyeleri kapatma fonksiyonu
        function collapseChildren(parentId) {
            const children = document.querySelectorAll(`.tree-row[data-parent='${parentId}']`);
            children.forEach(child => {
                child.style.display = 'none';
                const childId = child.getAttribute('data-id');
                collapseChildren(childId); // recursive kapatma
                const icon = document.querySelector(`.toggle-icon[data-toggle='${childId}']`);
                if (icon) icon.textContent = '▶';
            });
        }

        // İlk yüklemede tüm satırları gizle (sadece seviye 0 kalsın)
        document.querySelectorAll('.tree-row').forEach(row => {
            if (row.getAttribute('data-level') != "0") {
                row.style.display = 'none';
            }
        });
    });
</script>