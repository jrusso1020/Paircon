function initializeHeader() {
    $(document).ready(function () {
        $('.dropzone').not('.static').html5imageupload();
    });
}

var current_tab;

function requestTabPane(id, tab_name) {
    Cookies.set(id + '_current_tab', tab_name);
    $('.tab_ajax').parent().removeClass('active');
    $('#' + tab_name).parent().addClass('active');


    $.ajax({
        type: 'GET',
        url: '/conferences/' + id + '/' + tab_name,
        beforeSend: function () {
            $('#content').empty();
            showProcessingMsg('Please wait while we process your request ...');
            $('#spinner').show();
            $('#content').hide();
        },
        success: function (html) {
            hideProcessingMsg();
            $('#spinner').hide();
            $('#content').show();
            $('#content').html(html);
        }
    });
}

function initializeTabPanes(id) {
    $('.tab_ajax').click(function () {
        current_tab = $(this).attr('id');
        requestTabPane(id, current_tab);
    });
    if (typeof Cookies.get(id + '_current_tab') === 'undefined') {
        current_tab = 'home';
        Cookies.set(id + '_current_tab', 'home');
    } else {
        current_tab = Cookies.get(id + '_current_tab');
    }

    requestTabPane(id, current_tab);
}

function initializeConference(id, description, start_date, end_date) {
    initializeInPlaceEditing(id);
    retrievePosts(id);

    $('#reservation-time').daterangepicker({
        startDate: start_date,
        endDate: end_date,
        timePicker: true,
        timePickerIncrement: 15,
        opens: "left",
        locale: {
            format: 'DD MMM YYYY h:mm A'
        }
    }, function (start, end) {
        $.ajax({
            type: 'PUT',
            url: '/conferences/' + id,
            data: {
                'conference[start_date]': moment(new Date(start)).format('ddd, D MMM YYYY H:mm:ss'),
                'conference[end_date]': moment(new Date(end)).format('ddd, D MMM YYYY H:mm:ss'),
                'redirect': false
            },
            success: function (text, status, xhr) {
                showNotificationMsg('Your Conference has been successfully updated.');
                $.pjax.reload('[data-pjax-container]');
            },
            error: function (xhr, status, text) {
                showErrorMsg(xhr.responseText);
            }
        });
    });

    $('.read-more-description-' + id).on('click', function (e) {
        e.preventDefault()
        $(this).parent().html("'" + description + "'")
    })

    $('.inputfit').inputfit({
        maxSize: 20,
        minSize: 14
    });

}
var map, autocomplete, conference_id;

function initAutocomplete(input_field, id) {
    autocomplete = new google.maps.places.Autocomplete(
        /** @type {!HTMLInputElement} */(input_field),
        {types: ['geocode']});

    conference_id = id

//    autocomplete.bindTo('bounds', map);

    autocomplete.addListener('place_changed', fillInAddress);
}

function fillInAddress() {
    var place = autocomplete.getPlace();

    $.ajax({
        type: 'PUT',
        url: '/conferences/' + conference_id,
        data: {
            'conference[lat]': place.geometry.location.lat,
            'conference[long]': place.geometry.location.lng,
            'redirect': false
        }
    });

}

function geolocate() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            var geolocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
//            var circle = new google.maps.Circle({
//                center: geolocation,
//                radius: position.coords.accuracy
//            });
//            autocomplete.setBounds(circle.getBounds());
        });
    }
}

function initializeInPlaceEditing(id) {
    $(".best_in_place").best_in_place();

    $(".best_in_place").click(function () {
        if ($(this).attr('id') == 'phone-number') {
            $('#phone-number input').inputmask("phone");
        } else if ($(this).attr('id') == 'address-in-place') {
            initAutocomplete($('#address-in-place input')[0], id);
            geolocate();
        }

        $(this).css({
            "border-color": "#none",
            "border-width": "none",
            "border-style": "none"
        })
    });
    $(".best_in_place").hover(function () {
        if ($(this).children().length)
            return;

        $(this).css({
            "border-color": "#c6c6c6",
            "border-width": "1px",
            "border-style": "solid"
        })
    }, function () {
        $(this).css({
            "border-color": "#none",
            "border-width": "none",
            "border-style": "none"
        })
    })

    $('.best_in_place').bind("ajax:success", function (data, jqXHR, status) {
        var conference_name = $.parseJSON(jqXHR).text;
        document.title = conference_name + ' - PairCon';
        $('#conference_' + id).text(conference_name);
        showNotificationMsg('Your Conference has been successfully updated.');
    });

}

function retrievePosts(id) {
    $.ajax({
        type: 'GET',
        url: '/posts',
        data: {
            'conference_id': id
        },
        success: function (html) {
            $('.post_div').html(html);
            initializeInPlaceEditing(id);
        }
    });
}
function initializeFileUploader(conferenceid) {
    $('#uploadButton').text("Upload");
    $('#progress').hide();
    $('#fileName').text("");
    $(document).bind('drop dragover', function (e) {
        e.preventDefault();
    });

    $('#closeButton').click(function () {
        $('#uploadButton').text("Upload");
        $('#progress').hide();
        $('#fileName').text("");
    });

    $('#new_paper').validate({
        rules: {
            'paper[title]': {
                required: true
            }
        }
    });

    $('input[name="fileData"]').fileupload({
        singleFileUploads: true,

        multipart: false,
        url: '/papers?conference_id=' + conferenceid,
        sequentialUploads: true,
        singleFileUploads: true,
        dataType: 'json',
        dropZone: $('#drag-area'),
        method: 'POST',
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .bar').css(
                'width',
                progress + '%'
            );
        },
        done: function (e, data) {
            $('#closeButton').show();
            $('#cancelButton').hide();
        },
        add: function (e, data) {
            $('#fileName').text("[" + data.files[0].name + "]");
            $('#uploadButton').removeClass('disabled');
            var uploadurl = $('input[name="fileData"]').fileupload('option', 'url');
            $('#uploadButton').unbind();
            data.context = $('#uploadButton').click(function () {
                if($('#new_paper').valid()){
                    $('#uploadButton').text("Uploading");
                    $('#progress').fadeIn('slow');
                    $('#uploadButton').addClass('disabled');
                    $('#select-button').addClass('disabled');
                    $('#closeButton').hide();
                    $('#cancelButton').show();
                    $('input[name="fileData"]').fileupload('option', 'url', uploadurl + "&filename=" + data.files[0].name + "&filesize=" + data.files[0].size + "&paper[title]=" + $('#paper_title').val() + "&paper[author]=" + $('#paper_author').val() + "&paper[keywords]=" + $('#paper_keywords').val() + "&paper[year]=" + $('#paper_year').val() + "&paper[affiliation]=" + $('#paper_affiliation').val());
                    var jqXHR = data.submit()
                        .success(function (result, textStatus, jqXHR) {
                            var result_string = JSON.stringify(result);
                            showNotificationMsg(JSON.parse(result_string).message);
                            $('#modal').modal('hide');
                        })
                        .error(function (jqXHR, textStatus, errorThrown) {
                            var result_string = JSON.stringify(jqXHR.responseJSON);
                            result_string = JSON.parse(result_string);
                            showErrorMsg(result_string.message);
                        })
                        .complete(function (result, textStatus, jqXHR) {
                            $('#closeButton').show();
                            $('#cancelButton').hide();
                            $('#closeButton').click();
                            $.pjax.reload('[data-pjax-container]');
                            $('#uploadButton').removeClass('disabled');
                            $('#select-button').removeClass('disabled');
                        });

                    $('#cancelButton').click(function (e) {
                        $('#uploadButton').text("Upload");
                        $('#uploadButton').removeClass('disabled');
                        $('#select-button').removeClass('disabled');
                        $('#progress').hide();
                        jqXHR.abort();
                    });

                }else{
                    return false;
                }

            });
        }
    });

}

function initCharts(count) {

    try {
        var owl = $('.owl-carousel');
        owl.owlCarousel({
            items: count,
            loop: count > 1,
            autoplay: count > 1,
            autoplayTimeout: 4000
        });

        //Easy Pie Chart
        $('.easypiechart').easyPieChart({
            barColor: "#34495e",
            trackColor: '#edeef0',
            scaleColor: '#d2d3d6',
            scaleLength: 5,
            lineCap: 'round',
            lineWidth: 6,
            size: 100,
            scaleColor: false,
            onStep: function (from, to, percent) {
                $(this.el).find('.percent').text(Math.round(percent));
            }
        });

        $('#updatePieCharts').on('click', function () {
            $('.easypiechart').each(function () {
                $(this).data('easyPieChart').update(Math.random() * 100);
            });
            return false;
        });
    }
    catch (e) {
    }
}
/****************************************************/
/********************** INVITES *********************/
/****************************************************/
function changeEmailButtonVisibilityAdvanced() {
    if ($('#emails2').tokenInput("get").length > 0) {
        $('#submitButton').removeClass('btn-disabled');
    } else {
        $('#submitButton').addClass('btn-disabled');
    }
}

function checkIfEmail(email) {
    var REGEX_EMAIL = '([a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*@' +
        '(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)';
    var re = new RegExp('^' + REGEX_EMAIL + '$', 'i');
    return email.match(re);
}

function instantiateInvites(id, json) {
    $("#emails2").tokenInput(json, {
        placeholder: "Email address",
        hintText: "Please type email addresses and press enter",
        noResultsText: "No results found. Please add email manually ...",
        searchingText: "Looking for Email Address ...",
        preventDuplicates: true,
        zindex: '99999',
        invalidTokenText: 'Enter a valid Email Address',
        theme: 'bootstrap',
        allowFreeTagging: true,
        propertyToSearch: "name",
        onAdd: function () {
            changeEmailButtonVisibilityAdvanced();
        },
        onDelete: function () {
            changeEmailButtonVisibilityAdvanced();
        },
        resultsFormatter: function (item) {
            item.id = item.id.toLowerCase();
            item.name = item.name.toLowerCase();
            return "<li><span style='margin-left: 5px;'> " + item.name + "</span></li>";
        },
        tokenFormatter: function (item) {
            item.id = item.id.toLowerCase();
            item.name = item.name.toLowerCase();
            var color;

            if (!checkIfEmail(item.name))
                return "<li style='background: #800000; border-color: #800000; color: #E6E7E8'><p>" + item.name + "</p></li>";
            else
                return "<li><p>" + item.name + "</p></li>";
        }
    });

    $('.email-note').autosize({placeholder: false});

    enableSwitchery();

    $('#send_mail_field_advanced > .switchery').click(function () {
        if (!$('#add_custom_message').is(":checked")) {
            $('#addMessageLink').html('Add a Custom Message');
            $('#email_field_advanced').hide();
            $('#email_field_advanced').val("");
        } else {
            $('#addMessageLink').html('Discard message');
            $('#email_field_advanced').show();
            $('#email_field_advanced').val("");
        }
    });

    $('#submitButton').click(function () {
        var arr = [];
        var tokens = $("#emails2").tokenInput("get");
        for (var i = 0; i < tokens.length; i++) {
            if (checkIfEmail(tokens[i].name)) {
                if (tokens[i].id != tokens[name]) {
                    arr.push(tokens[i].id);
                } else {
                    arr.push(tokens[i].name);
                }
            }
        }

        $.ajax({
            type: 'POST',
            url: '/conferences/' + id + '/create_invites',
            data: {
                emails: arr.join(),
                sendcopy: $('#send_copy').is(':checked'),
                notifyemail: $('#add_custom_message').is(':checked'),
                optionalmessage: $('#mail_message_2').val()
            },
            beforeSend: function () {
                showProcessingMsg();
            },
            success: function (text, status, xhr) {
                $.pjax.reload('#wrap');
                showNotificationMsg(text);
            },
            error: function (xhr, status, text) {
                showErrorMsg(xhr.responseText);
            }
        });
    });
}

/*****************************************************/
/********************** SCHEDULE *********************/
/*****************************************************/
function updateEvent(id, resource_id, start_date, end_date, revertFunc) {
    $.ajax({
        type: 'POST',
        url: '/schedules/update_event',
        data: {
            'event[start_date]': start_date,
            'event[end_date]': end_date,
            'event[resource_id]': resource_id,
            'update_dates': true,
            'id': id
        },
        error: function (xhr, status, text) {
            revertFunc();
        }
    });
}

function cacheEventDate(conference_id) {
    var moment = $('.scheduler').fullCalendar('getDate');
    Cookies.set(conference_id + '_current_date', moment.startOf('day').format('LL'));
}

function getCachedDate(conference_id, start_date_str, end_date_str) {
    var start_date = new Date(start_date_str);
    var end_date = new Date(end_date_str);

    var start_date_moment = moment(start_date);
    var end_date_moment = moment(end_date);

    if (typeof Cookies.get(conference_id + '_current_date') === 'undefined') {
        return start_date_moment;
    } else {
        var cached_date = new Date(Cookies.get(conference_id + '_current_date'));
        var cached_moment = moment(cached_date);
        if (cached_moment.isSameOrAfter(start_date_moment, 'day') && cached_moment.isSameOrBefore(end_date_moment, 'day')) {
            return cached_moment.toISOString();
        } else {
            return start_date_moment;
        }
    }
}

function initializeSchedule(start_date_str, end_date_str, date_diff, enabled, conference_id) {

    $(function () { // document ready
        dateNow = getCachedDate(conference_id, start_date_str, end_date_str);

        $('.scheduler').fullCalendar({
            schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
            now: dateNow,
            selectable: enabled,
            selectHelper: enabled,
            editable: enabled,
            eventStartEditable: enabled,
            eventDurationEditable: enabled,
            filterResourcesWithEvents: !enabled,
            validRange: {
                start: moment(new Date(start_date_str)),
                end: moment(new Date(end_date_str)),
            },
            aspectRatio: 1.8,
            scrollTime: '08:00',
            header: {
                left: 'title',
                right: 'timelineDay,agendaDay,timelineNDays prev,next'
            },
            customButtons: {
                prev: {
                    icon: 'left-single-arrow',
                    click: function () {
                        $('.scheduler').fullCalendar('prev');
                        cacheEventDate(conference_id);
                    }
                },
                next: {
                    icon: 'right-single-arrow',
                    click: function () {
                        $('.scheduler').fullCalendar('next');
                        cacheEventDate(conference_id);
                    }
                }
            },
            defaultView: 'timelineDay',
            views: {
                timelineNDays: {
                    type: 'timeline',
                    duration: {days: date_diff},
                    buttonText: 'Complete Event'
                },
                timelineDay: {
                    type: 'day',
                    buttonText: 'Day (Horizontal)'
                },
                agendaDay: {
                    type: 'agendaDay',
                    buttonText: 'Day (Vertical)'
                }
            },
            resourceGroupField: 'building',
            refetchResourcesOnNavigate: true,
            resources: '/schedules/get_resources?id=' + conference_id,
            events: '/schedules/get_events?id=' + conference_id,
            eventResize: function (event, delta, revertFunc) {
                if (enabled)
                    updateEvent(event.id, event.resourceId, event.start.format(), event.end.format(), revertFunc);
            },
            eventDrop: function (event, delta, revertFunc) {
                if (enabled)
                    updateEvent(event.id, event.resourceId, event.start.format(), event.end.format(), revertFunc);
            },
            resourceRender: function (resource, cellEls) {
                if (enabled)
                    cellEls.find('div:last').append('<a class="flex-grow" style="margin-right: 10px;" data-toggle="modal" data-target="#modal" data-backdrop="static" href="' + '/schedules/delete_resource?id=' + resource.id + '"><i class="pull-right fa fa-trash"></i></a>')
            },
            eventClick: function (calEvent, jsEvent, view) {
                if (enabled)
                    $('#modal').modal({
                        remote: '/schedules/edit_event?id=' + calEvent.id,
                        backdrop: 'static'
                    })
            },
            select: function (start, end, jsEvent, view, resource) {
                if (enabled)
                    $('#modal').modal({
                        remote: '/schedules/new_event?conference_id=' + conference_id + '&resource_id=' + resource.id + '&start_date=' + start.format() + '&end_date=' + end.format(),
                        backdrop: 'static'
                    })
            }
        });
    });
}

function initializeAddScheduleResource() {
    initializeSelectize();

    try {
        $('*[data-depends-on]').each(function () {
            var $this = $(this);
            var master = $this.data('dependsOn').toString();
            var value = $this.data('dependsOnValue');
            if (typeof(value) != 'undefined') {
                $this.dependsOn(master, value);
            } else {
                $this.dependsOn(master);
            }
        });
    } catch (err) {
    }

    $('#add_resource_form').validate({
        rules: {
            'resource[title]': {
                required: true
            },
            'resource[parent_id[': {
                required: true
            }
        }
    });
}

function initializeAddScheduleEvent(start_date, end_date) {
    initializeSelectize();

    var options = {
        sideBySide: true,
        minDate: start_date,
        maxDate: end_date,
        stepping: 15,
        format: 'DD MMM YYYY h:mm A'
    };

    $('.datetime').datetimepicker(options);

    var auditorium_depend, $auditorium_depend;
    var room_depend, $room_depend;

    $auditorium_depend = $('#auditorium_depend').selectize({
        sortField: 'text',
        onChange: function (value) {
            if (!value.length) return;

            room_depend.disable();
            room_depend.clearOptions();
            room_depend.load(function (callback) {
                $.ajax({
                    url: '/schedules/get_rooms',
                    data: {
                        'id': value
                    },
                    success: function (results) {
                        room_depend.enable();
                        callback(results);
                        room_depend.addItem('No Room', false);
                    },
                    error: function () {
                        callback();
                    }
                })
            });
            room_depend.refreshOptions();
        }
    });

    $room_depend = $('#room_depend').selectize({
        sortField: 'text'
    });

    auditorium_depend = $auditorium_depend[0].selectize
    room_depend = $room_depend[0].selectize

    jQuery.validator.addMethod("greaterThan",
        function (value, element, params) {

            if (!/Invalid|NaN/.test(new Date(value))) {
                return new Date(value) > new Date($(params).val());
            }

            return isNaN(value) && isNaN($(params).val())
                || (Number(value) > Number($(params).val()));
        }, 'End Date must be greated than Start Date.');

    $('#event_form').validate({
        rules: {
            'event[title]': {
                required: true
            },
            'event[resource_auditorium]': {
                required: true
            },
            'event[start_date]': {
                required: true
            },
            'event[end_date]': {
                required: true,
                greaterThan: "#start_date_datepicker"
            }
        }
    });
}

function initializeSelectize() {
    $('.select').selectize({
        sortField: 'text'
    });
}