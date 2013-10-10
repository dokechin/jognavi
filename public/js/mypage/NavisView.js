var NavisView = Backbone.View.extend({
    el: '#navis_view',
	initialize: function() {
	    this.render();
	},
    render: function() {
     $('#navis_view').empty();
      this.collection.each(function(navi) {
        var naviView = new NaviView({model: navi});
        this.$el.append(naviView.render().el);
      }, this);
      return this;
    }

});



