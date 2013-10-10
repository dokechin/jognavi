var SearchRouter = Backbone.Router.extend({

	initialize: function() {

        this.mapView = new MapView({el: '#map_canvas', model : global_map, collection : global_routes});
        this.routesView = new RoutesView({collection: global_routes});
//        this.addressInputView = new AddressInputView({el: '#address_input', map: this.map});
	},
	routes: {
		"": "main"
	},
	main: function() {
	}
});

