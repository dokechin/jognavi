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
	add: function(event){
	    g_my_equipments.create(this.model);
	}

});



