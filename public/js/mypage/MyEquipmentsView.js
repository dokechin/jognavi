var MyEquipmentsView = Backbone.View.extend({
    el: '#my_equipments_view',
    url: '/equipment',
	initialize: function() {
	    this.render();
	    this.listenTo(this.collection,"reset",this.render);
	},
    render: function() {
        this.$el.append(g_grid.render().$el);
    }

});



