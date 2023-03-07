<cf_box title="Ürün Dizayn">
<ul id="sortable1" class="connectedSortable">
    <li class="ui-state-default">Item 1</li>
    <li class="ui-state-default">Item 2</li>
    <li class="ui-state-default">Item 3</li>
    <li class="ui-state-default">Item 4</li>
    <li class="ui-state-default">Item 5</li>
  </ul>
   
  <ul id="sortable2" class="connectedSortable">
    <li class="ui-state-highlight">Item 1</li>
    <li class="ui-state-highlight">Item 2</li>
    <li class="ui-state-highlight">Item 3</li>
    <li class="ui-state-highlight">Item 4</li>
    <li class="ui-state-highlight">Item 5</li>
  </ul>

  <script>
    $( function() {
    $( "#sortable1, #sortable2" ).sortable({
      connectWith: ".connectedSortable"
    }).disableSelection();
  } );
  </script>
  </cf_box>