<cfscript> 
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
    WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = 'list';
	
    WOStruct['#attributes.fuseaction#']['list'] = structNew();
    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
    WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_pbs_offer';
    WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/Partner/satis/display/list_pbs_offer.cfm';
    
    WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_pbs_offer';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/Partner/satis/form/add_pbs_offer.cfm';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_upd_pbs_offer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/Partner/satis/form/upd_pbs_offer.cfm';
   

	fuseactController = attributes.fuseaction;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();


	if(attributes.event is 'upd')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = 'Kopyala';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['onClick'] = "windowopen('#request.self#?fuseaction=sales.emptypopup_copy_pbs_offer&offer_id=#url.offer_id#','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = 'Fiyat Talepleri';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['money']['onClick'] = "windowopen('#request.self#?fuseaction=sales.emptypopup_list_pbs_offer_price_offerings&offer_id=#url.offer_id#','page');";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = 'Yazdır';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.offer_id#&print_type=1451&action_type=','WOC');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	/*
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'Satış Siparişleri';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = 'openList(1)';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = 'Satış Teklifleri';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = 'openList(2)';

	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);*/
</cfscript>