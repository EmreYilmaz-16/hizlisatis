    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.0/polyfill.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.1.1/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.2/FileSaver.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.0.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.9/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.7.1/jszip.js" integrity="sha512-NOmoi96WK3LK/lQDDRJmrobxa+NMwVzHHAaLfxdy0DRHIBc6GZ44CRlYDmAKzg9j7tvq3z+FGRlJ4g+3QC2qXg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/event.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/supplemental.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/unresolved.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/message.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/number.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/currency.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/date.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.common.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.light.css" />
    <script src="https://cdn3.devexpress.com/jslib/20.2.4/js/dx.all.js"></script>

    <div class="demo-container">
      <div id="gridContainer"></div>
    </div>


    <script>
const customers = [{
  ID: 1,
  CompanyName: 'Super Mart of the West',
  Address: '702 SW 8th Street',
  City: 'Bentonville',
  State: 'Arkansas',
  Zipcode: 72716,
  Phone: '(800) 555-2797',
  Fax: '(800) 555-2171',
  Website: 'http://www.nowebsitesupermart.com',
}, {
  ID: 2,
  CompanyName: 'Electronics Depot',
  Address: '2455 Paces Ferry Road NW',
  City: 'Atlanta',
  State: 'Georgia',
  Zipcode: 30339,
  Phone: '(800) 595-3232',
  Fax: '(800) 595-3231',
  Website: 'http://www.nowebsitedepot.com',
}, {
  ID: 3,
  CompanyName: 'K&S Music',
  Address: '1000 Nicllet Mall',
  City: 'Minneapolis',
  State: 'Minnesota',
  Zipcode: 55403,
  Phone: '(612) 304-6073',
  Fax: '(612) 304-6074',
  Website: 'http://www.nowebsitemusic.com',
}, {
  ID: 4,
  CompanyName: "Tom's Club",
  Address: '999 Lake Drive',
  City: 'Issaquah',
  State: 'Washington',
  Zipcode: 98027,
  Phone: '(800) 955-2292',
  Fax: '(800) 955-2293',
  Website: 'http://www.nowebsitetomsclub.com',
}, {
  ID: 5,
  CompanyName: 'E-Mart',
  Address: '3333 Beverly Rd',
  City: 'Hoffman Estates',
  State: 'Illinois',
  Zipcode: 60179,
  Phone: '(847) 286-2500',
  Fax: '(847) 286-2501',
  Website: 'http://www.nowebsiteemart.com',
}, {
  ID: 6,
  CompanyName: 'Walters',
  Address: '200 Wilmot Rd',
  City: 'Deerfield',
  State: 'Illinois',
  Zipcode: 60015,
  Phone: '(847) 940-2500',
  Fax: '(847) 940-2501',
  Website: 'http://www.nowebsitewalters.com',
}, {
  ID: 7,
  CompanyName: 'StereoShack',
  Address: '400 Commerce S',
  City: 'Fort Worth',
  State: 'Texas',
  Zipcode: 76102,
  Phone: '(817) 820-0741',
  Fax: '(817) 820-0742',
  Website: 'http://www.nowebsiteshack.com',
}, {
  ID: 8,
  CompanyName: 'Circuit Town',
  Address: '2200 Kensington Court',
  City: 'Oak Brook',
  State: 'Illinois',
  Zipcode: 60523,
  Phone: '(800) 955-2929',
  Fax: '(800) 955-9392',
  Website: 'http://www.nowebsitecircuittown.com',
}, {
  ID: 9,
  CompanyName: 'Premier Buy',
  Address: '7601 Penn Avenue South',
  City: 'Richfield',
  State: 'Minnesota',
  Zipcode: 55423,
  Phone: '(612) 291-1000',
  Fax: '(612) 291-2001',
  Website: 'http://www.nowebsitepremierbuy.com',
}, {
  ID: 10,
  CompanyName: 'ElectrixMax',
  Address: '263 Shuman Blvd',
  City: 'Naperville',
  State: 'Illinois',
  Zipcode: 60563,
  Phone: '(630) 438-7800',
  Fax: '(630) 438-7801',
  Website: 'http://www.nowebsiteelectrixmax.com',
}, {
  ID: 11,
  CompanyName: 'Video Emporium',
  Address: '1201 Elm Street',
  City: 'Dallas',
  State: 'Texas',
  Zipcode: 75270,
  Phone: '(214) 854-3000',
  Fax: '(214) 854-3001',
  Website: 'http://www.nowebsitevideoemporium.com',
}, {
  ID: 12,
  CompanyName: 'Screen Shop',
  Address: '1000 Lowes Blvd',
  City: 'Mooresville',
  State: 'North Carolina',
  Zipcode: 28117,
  Phone: '(800) 445-6937',
  Fax: '(800) 445-6938',
  Website: 'http://www.nowebsitescreenshop.com',
}];

    	$(() => {
  $('#gridContainer').dxDataGrid({
    dataSource: customers,
    keyExpr: 'ID',
    columns: ['CompanyName', 'City', 'State', 'Phone', 'Fax'],
    showBorders: true,
  });
});

    </script>