var EquipmentView = Backbone.View.extend({
    model : Equipment,
    tagName : "li",
    template : _.template( '<img alt="{{- name }}" src="{{- img }}"/><a href="{{= url }}">{{- name }}</a>{{- price }}<a href="{{= store_url }}">{{- store_name }}</a>' +
    '<button>追加</button>'),
    events: {
        'click button' : function ( event ) {
            this.add( event);
        }
    },
	initialize: function() {
        this.listenTo(this.model, 'change', this.render);
	},
	render: function(){
	    var value = this.template( this.model.toJSON());
        this.$el.html(value);
        return this;
	},
	add: function(e){
	    e.preventDefault();
	    g_my_equipments.create({ 
	    name : this.model.get("name"),
	    url: this.model.get("url"),
	    img: this.model.get("img"),
	    store_name : this.model.get("store_name"),
	    store_url : this.model.get("store_url"),
	    distance : this.model.get("distance")});
	}

});



