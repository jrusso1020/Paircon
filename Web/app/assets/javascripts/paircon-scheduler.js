
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

        $('#conference_scheduler').fullCalendar({
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

function initializeScheduleUserEvents() {
    $(document).ready(function() {
        $('#user_scheduler').fullCalendar({
            schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
            contentHeight: 650,
            selectable: false,
            selectHelper: false,
            editable: false,
            eventStartEditable: false,
            eventDurationEditable: false,
            filterResourcesWithEvents: false,
            eventLimit: true,
            scrollTime: '08:00',
            header: {
                left: 'title',
                right: 'monthView,weekView,dayView,listWeekView prev,next'
            },
            defaultView: 'timelineDay',
            views: {
                weekView: {
                    type: 'agendaWeek',
                    buttonText: 'Week'
                },
                listWeekView: {
                    type: 'listWeek',
                    buttonText: 'List'
                },
                dayView: {
                    type: 'agendaDay',
                    buttonText: 'Day'
                },
                monthView: {
                    type: 'month',
                    buttonText: 'Month'
                }
            },

            events: '/schedules/get_events_user'
        });
    });
}