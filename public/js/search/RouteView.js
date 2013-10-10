var RouteView = Backbone.View.extend({
    tagName: "tr",
    className: "route",
    events: {
        'click #register' : 'favorite',
        'click #unregister' : 'unfavorite',
        'click td' : 'detail'
    },
	initialize: function() {
	    this.template = _.template($("#route_template").html());
        this.listenTo(this.model, 'change', this.render);	    
	},
	render: function(){
        this.$el.html(this.template( this.model.toJSON()));
        return this;
	},
	detail: function(e){
        e.preventDefault();
	    window.open( '/route/' + this.model.id ,'_blank');
	},
	favorite: function(e){
        e.preventDefault();
        e.stopImmediatePropagation();
	    var model = this.model;

        //jsonファイルの取得
        $.ajax({
          url: '/favorite/' + this.model.id,
          type: 'POST',
          dataType: 'json',
          timeout: 10000,
          error: function(){
              alert("登録失敗しました");
          },
          success: function(json){
              model.set("mycourse" , 1);
          }
        });
	},
	unfavorite: function(e){
        e.preventDefault();
        e.stopImmediatePropagation();
	    var model = this.model;
        //jsonファイルの取得
        $.ajax({
          url: '/unfavorite/' + this.model.id,
          type: 'POST',
          dataType: 'json',
          timeout: 10000,
          error: function(){
              alert("登録失敗しました");
          },
          success: function(json){
              model.set("mycourse" , 0);
          }
        });
	}

});



