var SessionTabs;
SessionTabs = function() {};
SessionTabs.Helpers = {
  setButtonToSubmit: function(buttonDom) {
    buttonDom.text(buttonDom.attr('value'));
    buttonDom.attr("value", "Submitting...");
    return buttonDom.attr('disabled', 'disabled');
  },
  setButtonToEnabled: function(buttonDom) {
    buttonDom.attr('value', buttonDom.text());
    return buttonDom.attr('disabled', '');
  },
  addValidationError: function(error, message) {
    var field_id, label;
    field_id = "user_" + error;
    label = $("label[for='" + field_id + "']");
    error = $("#" + field_id + "_validation");
    label.addClass('inline_validation_error');
    error.text(message[0]);
    return error.addClass('inline_validation_error');
  },
  clearValidationErrors: function() {
    $('span.inline_validation_error').text("");
    return $('label').removeClass('inline_validation_error');
  }
};
SessionTabs.bindNavigation = function() {
  return $('#main_tab_menu').tabs({
    ajaxOptions: {
      error: function(xhr, status, index, anchor) {
        return $(anchor.hash).html("We're having trouble,  Please try again in a little while.");
      },
      success: function(data, status, xhr) {
        SessionTabs.bindActions();
        SessionTabs.registrationForm.bind();
        SessionTabs.signinForm.bind();
        return SessionTabs.newPasswordForm.bind();
      }
    }
  });
};
SessionTabs.bindActions = function() {
  $('.gotoLogin').click(function() {
    return $('#main_tab_menu').tabs('select', 0);
  });
  $('.gotoSignup').click(function() {
    return $('#main_tab_menu').tabs('select', 1);
  });
  return $('.gotoForgotPassword').click(function() {
    var element;
    element = $('#main_tab_menu');
    if (element.tabs('length') < 3) {
      element.tabs('add', '/users/password/new', 'Password reset');
    }
    return element.tabs('select', 2);
  });
};
SessionTabs.tabForm = {
  bind: function() {
    var afterError, afterSuccess, buttonDom, containerDom, formDom;
    containerDom = $(this.containerSelector);
    formDom = $("" + this.containerSelector + " form");
    buttonDom = $("" + this.containerSelector + " form input[type='submit']");
    afterSuccess = this.afterSuccess || function() {};
    afterError = this.afterError || function() {};
    formDom.bind('ajax:beforeSend', function() {
      SessionTabs.Helpers.setButtonToSubmit(buttonDom);
      return SessionTabs.Helpers.clearValidationErrors();
    });
    formDom.bind('ajax:success', function(event, data, success, xhr) {
      SessionTabs.Helpers.setButtonToEnabled(buttonDom);
      return afterSuccess(event, data, success, xhr);
    });
    return formDom.bind('ajax:error', function(evt, xhr, status, error) {
      SessionTabs.Helpers.setButtonToEnabled(buttonDom);
      return afterError(evt, xhr, status, error);
    });
  },
  flash: function(message_array) {
    var text, text_div;
    $("" + this.containerSelector + " .flash").css("display", "block");
    text_div = $("" + this.containerSelector + " .flash div");
    text = message_array.notice ? message_array.notice : message_array[0];
    text_div.text(text);
    return text_div.hide().fadeIn("slow");
  }
};
SessionTabs.registrationForm = {
  containerSelector: '#registration_form_container',
  afterSuccess: function(event, data, success, xhr) {
    return window.location = "/homepage";
  },
  afterError: function(event, xhr, status, error) {
    var message, response, _results;
    response = $.parseJSON(xhr.responseText);
    _results = [];
    for (error in response) {
      message = response[error];
      _results.push(SessionTabs.Helpers.addValidationError(error, message));
    }
    return _results;
  }
};
$.extend(SessionTabs.registrationForm, SessionTabs.tabForm);
SessionTabs.signinForm = {
  containerSelector: '#signin_form_container',
  afterSuccess: function(event, data, success, xhr) {
    return window.location = "/homepage";
  },
  afterError: function(event, xhr, status, error) {
    var response;
    response = $.parseJSON(xhr.responseText);
    if (response.status === "unauthenticated") {
      return SessionTabs.signinForm.flash(response.errors);
    }
  }
};
$.extend(SessionTabs.signinForm, SessionTabs.tabForm);
SessionTabs.newPasswordForm = {
  containerSelector: '#forgot_password_form_container',
  afterSuccess: function(event, data, success, xhr) {
    var response;
    response = $.parseJSON(xhr.responseText);
    return SessionTabs.newPasswordForm.flash(response);
  },
  afterError: function(event, xhr, status, error) {
    var error_container, message, response, _results;
    error_container = $('#forgot_password_error_message');
    response = $.parseJSON(xhr.responseText);
    _results = [];
    for (error in response) {
      message = response[error];
      _results.push(SessionTabs.Helpers.addValidationError(error, message));
    }
    return _results;
  }
};
$.extend(SessionTabs.newPasswordForm, SessionTabs.tabForm);
$(function() {
  SessionTabs.bindNavigation();
  return SessionTabs.bindActions();
});