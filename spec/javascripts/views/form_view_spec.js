describe("FormView", function(){
  var view;
  var model;

  beforeEach(function() {
    model = new Backbone.Model({id: 1, name: 'test'});
    view = new FormView({model: model})
    view.el = $('<form id="petition_form">'
                + '<input name="petition[title]" value="test title" id="petition_title">'
                + '<label for="petition_title" id="petition_title_errors"></label>'
                + '</form>');
  });

  describe("#persist", function(){
    it("should copy values from form to the model", function(){
      expect(view.persist().model.get('title')).toEqual('test title');
    });
  });

  describe("#handleErrors", function(){
    it("should display errors inline with the fields", function(){
      var errors = {title : ["Can't be blank"]};
      view.handleErrors(model, errors);
      expect(view.$('#petition_title_errors').html()).toEqual("Can't be blank");
    });
  });

});
