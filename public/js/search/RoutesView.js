var RoutesView = Backbone.View.extend({
    el: '#routes_view',
	initialize: function() {
	    this.listenTo(this.collection, 'reset', this.render);
	},
    render: function() {
     $('#routes_view').empty();
      this.$el.append(
             '<tr>' +
               '<th>コース名</th>' +
               '<th>色</th>' +
               '<th>距離(km)</th>' +
               '<th>マイコース</th>' +
             '</tr>');
      this.collection.each(function(route) {
        var routeView = new RouteView({model: route});
        this.$el.append(routeView.render().el);
      }, this);
      return this;
    }

});



