function add_order2()
	{
		if((document.formBasket2.company_id.value == '' && document.formBasket2.consumer_id.value == '') ||  document.formBasket2.company.value == '')
		{
			alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
		if(document.formBasket2.deliver_dept_name.value == '' && document.formBasket2.deliver_dept_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='36061.Depo seç'> !");
			return false;
		}
		if(document.formBasket2.deliverdate.value == '')
		{
			alert("<cf_get_lang dictionary_id='46856.Teslim Tarihi Girmelisiniz'> !");
			return false;
		}
	
		var convert_stocks_id ='';
		var convert_spect_id ='';
		var convert_amount_stocks_id ='';
		var convert_wrk_row_id ='';
		var convert_order_row_id ='';
		var convert_demand_row_id ='';
		var convert_product_id ='';
		zero_list = '';
		if(document.all.report_row_stock_id_.length != undefined)
		{
			var checked_item_ = document.all.report_row_stock_id_;
			var convert_stocks_id ='';
			var convert_amount_stocks_id ='';
			var convert_spect_id ='';
			var convert_wrk_row_id ='';
			var convert_order_row_id ='';
			var convert_demand_row_id ='';
			var convert_product_id ='';
			for(var xx=0; xx < document.all.report_row_stock_id_.length; xx++)
			{
				console.log(checked_item_[xx])
				console.log($(checked_item_[xx]).is(":checked"));
				if($(checked_item_[xx]).is(":checked"))
				{
					var type=list_getat(checked_item_[xx].value,1,';');
					var action_row_id=list_getat(checked_item_[xx].value,2,';');
					var stock_id_=list_getat(checked_item_[xx].value,3,';');
					var spect_id_=list_getat(checked_item_[xx].value,4,';');
					var wrk_row_id_=list_getat(checked_item_[xx].value,5,';');
					var product_id_=list_getat(checked_item_[xx].value,6,';');
					var amount_old_=list_getat(checked_item_[xx].value,7,';');
					var amount=eval("document.formBasket2.demand_amount_"+wrk_row_id_).value;
					var product_name=eval("document.formBasket2.product_name_"+wrk_row_id_).value;
					if(amount > 0)
					{
						
						console.log(miktar=amount);
						var is_selected_row = 1;
						if(list_len(convert_stocks_id,',') == 0)
						{
							if(type == 1)
								convert_order_row_id+=action_row_id;
							else
								convert_demand_row_id+=action_row_id;
							convert_wrk_row_id+=wrk_row_id_;
							convert_stocks_id+=stock_id_;
							convert_product_id+=product_id_;
							convert_amount_stocks_id+=amount;
							convert_spect_id+=spect_id_;
						}
						else
						{
							if(type == 1)
							{
								if(list_len(convert_order_row_id,',') == 0)
									convert_order_row_id+=action_row_id;
								else
									convert_order_row_id+=","+action_row_id;
							}
							else
							{
								if(list_len(convert_demand_row_id,',') == 0)
									convert_demand_row_id+=action_row_id;
								else
									convert_demand_row_id+=","+action_row_id;
							}
							convert_wrk_row_id+=","+wrk_row_id_;
							convert_product_id+=","+product_id_;
							convert_amount_stocks_id+=","+amount;
							convert_spect_id+=","+spect_id_;
						}
					}
					else
					{
						
						if(list_len(zero_list,',') == 0)
							zero_list+=product_name;
						else
							zero_list+=","+product_name;
					}
				}
			}
		}
		else if(document.all.report_row_stock_id_)
		{
			var type=list_getat(document.all.report_row_stock_id_.value,1,';');
			var action_row_id=list_getat(document.all.report_row_stock_id_.value,2,';');
			var stock_id_=list_getat(document.all.report_row_stock_id_.value,3,';');
			var spect_id_=list_getat(document.all.report_row_stock_id_.value,4,';');
			var wrk_row_id_=list_getat(document.all.report_row_stock_id_.value,5,';');
			var product_id_=list_getat(document.all.report_row_stock_id_.value,6,';');
			var amount_old_=list_getat(document.all.report_row_stock_id_.value,7,';');
			var amount=eval("document.formBasket2.demand_amount_"+wrk_row_id_).value;
			var product_name=eval("document.formBasket2.product_name_"+wrk_row_id_).value;
			if(amount > 0)
			{
				var is_selected_row = 1;
				if(list_len(convert_stocks_id,',') == 0)
				{
					if(type == 1)
						convert_order_row_id+=action_row_id;
					else
						convert_demand_row_id+=action_row_id;
					convert_wrk_row_id+=wrk_row_id_;
					convert_stocks_id+=stock_id_;
					convert_product_id+=product_id_;
					convert_amount_stocks_id+=amount;
					convert_spect_id+=spect_id_;
				}
				else
				{
					if(type == 1)
					{
						if(list_len(convert_order_row_id,',') == 0)
							convert_order_row_id+=action_row_id;
						else
							convert_order_row_id+=","+action_row_id;
					}
					else
					{
						if(list_len(convert_demand_row_id,',') == 0)
							convert_demand_row_id+=action_row_id;
						else
							convert_demand_row_id+=","+action_row_id;
					}
					convert_wrk_row_id+=","+wrk_row_id_;
					convert_stocks_id+=","+stock_id;
					convert_product_id+=","+product_id_;
					convert_amount_stocks_id+=","+amount;
					convert_spect_id+=","+spect_id_;
				}
			}
			else
			{
				if(list_len(zero_list,',') == 0)
					zero_list+=product_name;
				else
					zero_list+=","+product_name;
			}
		}
		console.log(is_selected_row);
		if(is_selected_row == undefined)
		{
			alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
			return false;
		}
		else if(list_len(zero_list,',') != 0)
		{
			alert("<cf_get_lang dictionary_id='60631.Aşağıdaki Ürünler İçin Sipariş Miktarı Sıfır Olduğu İçin Baskete Atılmayacaktır'> !\n\n\n"+product_name);
		}
		if(list_len(convert_stocks_id,',') > 0)
		{
			convert_stocks_id+=0;
			var paper_date_ = js_date(formBasket2.date_new.value.toString() );
			var str_price_row="SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT PP WHERE PRODUCT_ID IN("+convert_product_id+") AND PRODUCT_ID NOT IN(SELECT P.PRODUCT_ID FROM PRICE P WHERE P.PRODUCT_ID = PP.PRODUCT_ID AND P.PRICE_CATID="+document.formBasket2.price_catid.value+" AND (FINISHDATE >="+paper_date_+" OR FINISHDATE IS NULL))";
			var get_price_row=wrk_query(str_price_row,"dsn3");
			if(get_price_row.recordcount)
			{
				fiyatsiz_urunler = '';
				for(kk=0;kk<get_price_row.recordcount;kk++)
					fiyatsiz_urunler = fiyatsiz_urunler + get_price_row.PRODUCT_NAME[kk] + '\n';
					
					$('.ui-cfmodal__alert .required_list li').remove();

						$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>Fiyatyok</li>');

						$('.ui-cfmodal__alert').fadeIn();
					return false;
			}
			document.all.convert_wrk_row_id.value=convert_wrk_row_id;
			document.all.convert_stocks_id.value=convert_stocks_id;
			document.all.convert_spect_id.value=convert_spect_id;
			document.all.convert_amount_stocks_id.value=convert_amount_stocks_id;
			document.all.convert_demand_row_id.value=convert_demand_row_id;
			document.all.convert_order_row_id.value=convert_order_row_id;
			if(document.getElementById('project_id') != undefined && document.getElementById('project_id').value != '' && document.getElementById('project_head') != undefined && document.getElementById('project_head').value != '')
			{
				document.all.convert_project_id.value = document.getElementById('project_id').value;
				document.all.convert_project_head.value = document.getElementById('project_head').value;
			}
			else
			{
				document.all.convert_project_id.value = '';
				document.all.convert_project_head.value = '';
			}
			document.formBasket2.action='<cfoutput>#request.self#?fuseaction=purchase.list_order&event=add&type=convert&is_from_report=1&is_wrk_row_id=1</cfoutput>';
			document.formBasket2.submit();
			return true;
		}
	}