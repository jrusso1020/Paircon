/***************************************************/
/******************** DASHBOARD ********************/
/***************************************************/
function changeTiles(upcomingConferenceHeader, upcomingConferenceBody, upcomingConferenceFooter, recommendedConferenceHeader, recommendedConferenceBody, recommendedConferenceFooter, popularConferenceHeader, popularConferenceBody, popularConferenceFooter) {
    $('#upcomingConferenceHeader').shuffleLetters({text: upcomingConferenceHeader});
    $('#upcomingConferenceBody').shuffleLetters({text: upcomingConferenceBody});
    $('#upcomingConferenceFooter').shuffleLetters({text: upcomingConferenceFooter});

    $('#recommendedConferenceHeader').shuffleLetters({text: recommendedConferenceHeader});
    $('#recommendedConferenceBody').shuffleLetters({text: recommendedConferenceBody});
    $('#recommendedConferenceFooter').shuffleLetters({text: recommendedConferenceFooter});

    $('#popularConferenceHeader').shuffleLetters({text: popularConferenceHeader});
    $('#popularConferenceBody').shuffleLetters({text: popularConferenceBody});
    $('#popularConferenceFooter').shuffleLetters({text: popularConferenceFooter});

    // var number = '';
    // var text = '';
    //
    // if (!(totalStorageSubTile.indexOf('∞') !== -1)) {
    //     animateNumber('#totalStorageSubTile', totalStorageSubTile.replace('%', ''), 1, '%', animateVal);
    // } else {
    //     $('#totalStorageSubTile').html(totalStorageSubTile);
    // }
    //
    // if (!(totalStorageTextTile.indexOf('∞') !== -1)) {
    //     number = totalStorageTextTile.split(' ')[0];
    //     text = totalStorageTextTile.replace(number, '');
    //     animateNumber('#totalStorageTextTile', number, 1, text, animateVal);
    // } else {
    //     $('#totalStorageTextTile').html(totalStorageTextTile);
    // }
    //
    // nextBestIcon = nextBestIcon.toLowerCase();
    //
    // if (nextBestIcon === 'dropbox') {
    //     $('#nextBestIcon').attr('src', '<%= asset_path "Dropbox-drive-icon-white.png" %>');
    // } else if (nextBestIcon === 'google-drive') {
    //     $('#nextBestIcon').attr('src', '<%= asset_path "GoogleDrive-drive-icon-white.png" %>');
    // }
    //
    // if (nextBestSubTile === 'N/A') {
    //     $('#nextBestTextTile').html(nextBestTextTile);
    // } else {
    //     number = nextBestTextTile.split(' ')[0];
    //     text = nextBestTextTile.replace(number, '');
    //     animateNumber('#nextBestTextTile', number, 1, text, animateVal);
    // }
    //
    // nextBestSubTile === 'N/A' ? animateNumber('#nextBestSubTile', nextBestSubTile, 1, '', animateVal) : animateNumber('#nextBestSubTile', nextBestSubTile.replace('%', ''), 1, '%', animateVal);
    //
    // $('#nextBestDriveName').html(nextBestDriveName === 'N/A' ? 'N/A' : (nextBestDriveName + spaceTitle));
    //
    // number = sharedTextTile.split(' ')[0];
    // text = sharedTextTile.replace(number, '');
    // animateNumber('#sharedTextTile', number, 0, text, animateVal);
    // animateNumber('#sharedSubTile', sharedSubTile.replace('%', ''), 0, '%', animateVal);
    //
    // number = tagsTextTile.split(' ')[0];
    // text = tagsTextTile.replace(number, '');
    // animateNumber('#tagsTextTile', number, 0, text, animateVal);
    //
    // animateNumber('#tagsSubTile', tagsSubTile, 0, '', animateVal);
}


(function ($) {
    $.fn.countTo = function (options) {
        // merge the default plugin settings with the custom options
        options = $.extend({}, $.fn.countTo.defaults, options || {});

        // how many times to update the value, and how much to increment the value on each update
        var loops = Math.ceil(options.speed / options.refreshInterval),
            increment = (options.to - options.from) / loops;

        return $(this).each(function () {
            var _this = this,
                loopCount = 0,
                value = options.from,
                interval = setInterval(updateTimer, options.refreshInterval);

            function updateTimer() {
                value += increment;
                loopCount++;
                $(_this).html(value.toFixed(options.decimals));

                if (typeof(options.onUpdate) == 'function') {
                    options.onUpdate.call(_this, value);
                }

                if (loopCount >= loops) {
                    clearInterval(interval);
                    value = options.to;

                    if (typeof(options.onComplete) == 'function') {
                        options.onComplete.call(_this, value);
                    }
                }
            }
        });
    };

    $.fn.countTo.defaults = {
        from: 0,  // the number the element should start at
        to: 100,  // the number the element should end at
        speed: 1000,  // how long it should take to count between the target numbers
        refreshInterval: 100,  // how often the element should be updated
        decimals: 0,  // the number of decimal places to show
        onUpdate: null,  // callback method for every time the element is updated,
        onComplete: null  // callback method for when the element finishes updating
    };
})(jQuery);

function animateNumber(id, toVal, decimals, text, animateVal) {
    if (toVal === '0' || toVal === '∞' || toVal === 'N/A') {
        $(id).html(toVal + text);
        return;
    }

    $(id).countTo({
        from: 0,
        to: +toVal,
        speed: animateVal === 'false' ? 0 : 2000,
        refreshInterval: 50,
        onUpdate: function (value) {
            $(this).text(value.toFixed(decimals) + text);
        }
    });
}

/***************************************************/
/********************** SEARCH *********************/
/***************************************************/
function initializeSearch(length) {
    var enable = length > 0;

    $.fn.dataTable.moment('MMMM D YYYY, h:mm a');

    $('.dataTable').DataTable({
        responsive: true,
        bSort: enable,
        bFilter: false,
        bInfo: false,
        bPaginate: false,
        bRetrieve: true,
        sDom: "<'row'<'col-xs-6'l><'col-xs-6'f>r>t<'row'<'col-xs-6'i><'col-xs-6'p>>",
        sPaginationType: "bootstrap",
        order: [[1, 'asc']],
        oLanguage: {
            "sEmptyTable": "",
            "sZeroRecords": ""
        },
        columnDefs: [
            {targets: 'no-sort', orderable: false},
            {type: 'datetime-moment', targets: [3, 4]}
        ]
    });

    removeEmptyRowsDataTable();
}