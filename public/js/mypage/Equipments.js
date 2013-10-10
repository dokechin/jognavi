var Equipments = Backbone.Paginator.requestPager.extend({
  model: Equipment,
  paginator_core: {
			// the type of the request (GET by default)
			type: 'GET',
			
			// the type of reply (jsonp by default)
			dataType: 'jsonp',
			
			// data cache 
			
			cache : false,
		
			// the URL (or base URL) for the service
			url: '//shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch?'
	},
  paginator_ui: {
		// the lowest page index your API allows to be accessed
		firstPage: 1,
		
		// which page should the paginator start from 
		// (also, the actual page the paginator is on)
		currentPage: 1,
			
		// how many items per page should be shown
		perPage: 20,
			
		// a default number of total pages to query in case the API or 
		// service you are using does not support providing the total 
		// number of pages for us.
		// 10 as a default in case your service doesn't return the total
		totalPages: 10
	},
  server_api: {
		// number of items to return per request/page
		'hits': function() { return this.perPage },

		// how many results the request should skip ahead to
		'offset': function() { return (this.currentPage - 1 ) * this.perPage },
			
		// field to sort by
		'sort': function() {
			if(this.sortField === undefined)
				return '%2Bscore';
			return this.sortField;
		},

		// custom parameters
		'callback': '?',
		'query' : function() { return this.query },
		'appid' :function (){ return "dj0zaiZpPThxSE0xWjMxRmFnZSZzPWNvbnN1bWVyc2VjcmV0Jng9MmE-"},
		'affiliate_type' :function (){ return "yid"},
		'affiliate_id' :function (){ return "E0yZg3502auv.l4O8F39DEpQ"},
		'category_id' :function (){ return "14894"},
		'image_size' :function (){ return "76"},
	},
  setQuery: function (value){
      this.query = value;
  },
  parse: function(resp, options) {
      var total_results_returned = resp.ResultSet.totalResultsReturned;
      var array = new Array();
      this.totalRecords = resp.ResultSet.totalResultsAvailable;
      for(var i=0;i< total_results_returned;i++){
          var result = resp.ResultSet[0].Result[i];
          var data = {};
          data.name = result.Name;
          data.url = result.Url;
          data.img = result.Image.Small;
          data.price = result.PriceLabel.SalePrice;
          data.store_name = result.Store.Name;
          data.store_url = result.Store.Url;
          array.push(data);
      }
      return array;
  }
});

  