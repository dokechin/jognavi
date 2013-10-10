var SearchView = Backbone.View.extend({
    //タグの種類
    el: '#search_view',
    //ボタンイベント
    events: {
      'submit': 'submit'
    },
    //ボタンを押された時の処理
    submit: function(e) {
      e.preventDefault();
      var query = $('#search_query').val();
	  g_equipments.setQuery(query);
	  g_equipments.fetch({reset : true});
    }
});