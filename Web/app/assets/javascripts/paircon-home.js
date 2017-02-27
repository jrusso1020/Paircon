// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
/****************************************/
//--------------PASSWORD----------------//
/****************************************/
function initializePasswordEdit() {
    $('#edit_user_password').validate({
        rules: {
            'user[password]': {
                required: true,
                minlength: 6,
                maxlength: 255
            },
            'user[password_confirmation]': {
                required: true,
                equalPassword: "#user_password"
            }
        }
    });
}

/****************************************/
//------------REGISTRATION--------------//
/****************************************/
function initializeNewRegistration() {
    $('.form-control').focus(function () {$(this).closest('a.custom-tooltip').children().first().css('opacity', '1.0'); });
    $('.form-control').blur(function () { $(this).closest('a.custom-tooltip').children().first().css('opacity', '0.0'); });
}

/****************************************/
//------------VALIDATIONS--------------//
/****************************************/
$.extend($.validator.messages, {
    required: I18n.t("required_field_msg"),
    email: I18n.t("invalid_email_address_msg"),
    equalTo: I18n.t('pls_enter_same_value_msg'),
    minlength: I18n.t('pls_enter_at_least_characters'),
    url: I18n.t('invalid_url_msg'),
    number: I18n.t('pls_enter_valid_number'),
    max: I18n.t('pls_enter_value_less_or_equal_max'),
    accept: ""
});

$.validator.setDefaults({
    errorClass: "error-message-no-label",
    validClass: "error-message-no-label",
    highlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group, .input-group').addClass("has-error");
    },
    unhighlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group, .input-group').removeClass("has-error");
    }
});

$.validator.addMethod("notEqualPassword", function (value, element) {
    return $('#user_password').val() != $('#user_current_password').val();
}, "Specify a new / different password");

$.validator.addMethod("equalPassword", function (value, element) {
    return $('#user_password').val() == $('#user_password_confirmation').val();
}, "Passwords don't match. Please try again ...");

$.validator.addMethod('noSpecialCaracters', function (value, element) {
    return value.match(/^[0-9a-z\s\-\_\!\(\)\/\,\.:+]*$/i);
}, I18n.t('no_special_chars_allowed_msg'));

$.validator.addMethod("without_protocol_url", function (value, element) {
    return $.validator.methods['url'].call(
        this, "http://" + value, element
    );
}, I18n.t('url_protocol_not_required_msg'));

function initSignUpValidation() {
    $('#new_user_registration').validate({
        ignore: [],
        rules: {
            'user[first_name]': 'required',
            'user[last_name]': 'required',
            'user[username]': {
                required: true,
                remote: "/users/validation",
                minlength: 4
            },
            // 'user[dob]': 'required',
            // 'user[country]': 'required',
            // 'user[gender]': 'required',
            // 'user[phone_number]': 'required',
            'user[email]': {
                required: true,
                email: true,
                maxlength: 255
            },
            'user[password]': {
                required: true,
                minlength: 6,
                maxlength: 255
            },
            'user[password_confirmation]': {
                required: true,
                equalPassword: "#user_password"
            }
        },
        messages: {
            'user[username]': {
                remote: jQuery.format("This username is already in use")
            }
        },
        highlight: function (element, errorClass, validClass) {
            $(element).parent().first().addClass("has-error");
            $('.' + $(element).attr('id')).hide();
        },
        unhighlight: function (element, errorClass, validClass) {
            $(element).parent().first().removeClass("has-error");
            $('.' + $(element).attr('id')).show();
        },
        success: function (element) {
            $(element).parent().first().removeClass("has-error");
            $('.' + element.attr('for')).show();
        }
    });
}

function initLoginBoxValidation() {
    $('#new_user_session').validate({
        rules: {
            'user[email]': {
                required: true,
                email: true
            },
            'user[password]': {
                required: true,
                minlength: 6,
                maxlength: 255
            }
        }
    });

    $('#new_user_password').validate({
        rules: {
            'user[email]': {
                required: true,
                email: true
            }
        }
    });

    $('#new_user_confirmation').validate({
        rules: {
            'user[email]': {
                required: true,
                email: true
            }
        }
    });

    $('#loginbox form').submit(function (e) {
        if (!$(this).valid()) {
            $('#loginbox').effect('shake');
            return false;
        }
    });

    $('#new_user_registration').validate({
        rules: {
            'user[first_name]': 'required',
            'user[last_name]': 'required',
            'user[email]': {
                required: true,
                email: true,
                remote: "/users/validation"
            },
            'user[password]': {
                required: true,
                minlength: 6,
                maxlength: 255
            },
            'user[password_confirmation]': {
                required: true,
                equalPassword: "#user_password"
            }
        },
        messages: {
            'user[email]': {
                remote: jQuery.format("This Email Address is already in use. Please try again ...")
            }
        },
        highlight: function (element, errorClass, validClass) {
            $(element).parent().first().addClass("has-error");
        }
        ,
        unhighlight: function (element, errorClass, validClass) {
            $(element).parent().first().removeClass("has-error");
        }
    });
}