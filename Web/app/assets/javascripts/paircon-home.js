/***************************************************/
/******************** DASHBOARD ********************/
/***************************************************/
function changeTiles(upcomingConferenceHeader, upcomingConferenceBody, upcomingConferenceFooter, recommendedConferenceHeader, recommendedConferenceBody, recommendedConferenceFooter, popularConferenceHeader, popularConferenceBody, popularConferenceFooter, totalRecommendationsHeader, totalRecommendationsBody, totalRecommendationsFooter) {
    $('#upcomingConferenceHeader').shuffleLetters({text: upcomingConferenceHeader});
    $('#upcomingConferenceBody').shuffleLetters({text: upcomingConferenceBody});
    $('#upcomingConferenceFooter').shuffleLetters({text: upcomingConferenceFooter});

    $('#recommendedConferenceHeader').shuffleLetters({text: recommendedConferenceHeader});
    $('#recommendedConferenceBody').shuffleLetters({text: recommendedConferenceBody});
    $('#recommendedConferenceFooter').shuffleLetters({text: recommendedConferenceFooter});

    $('#popularConferenceHeader').shuffleLetters({text: popularConferenceHeader});
    $('#popularConferenceBody').shuffleLetters({text: popularConferenceBody});
    $('#popularConferenceFooter').shuffleLetters({text: popularConferenceFooter});

    $('#totalRecommendationsHeader').shuffleLetters({text: totalRecommendationsHeader});
    $('#totalRecommendationsBody').shuffleLetters({text: totalRecommendationsBody});
    $('#totalRecommendationsFooter').shuffleLetters({text: totalRecommendationsFooter});
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