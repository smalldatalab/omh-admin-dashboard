var dsu = window.location.origin + "/dsu/";

function getDatapointId(username, date, device){
    return  ["mobility-daily-segments", username, date, device].join("-");
}

function getSummaryDatapointId(username, date, device){
    return  ["mobility-daily-summary", username, date, device.toLowerCase()].join("-");
}

