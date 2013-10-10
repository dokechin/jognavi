var Route = Backbone.Model.extend({
  defaults : {
    id : "",
    name : "",
    start_address : "",
    description : "",
}});

var RouteView = Backbone.View.extend({
    model : Route,
    
    template : _.template( '<h2><a href="/route/{{- id }}">{{- name }}</a></h2><p>{{- start_address }}</p><p>{{- description }}</p>'),
    tagName : 'li',
    
	initialize: function(el) {

        this.el = el;
        this.listenTo(this.model, 'change', this.render);
        this.render();

	},
	
    events: {
        "click":          "display",
    },

	render: function() {
        var data = this.model.toJSON();
        var html = this.template(data);
//        var html = this.template(this.model.attributes);
	    this.$el.html(html);
	}

});


