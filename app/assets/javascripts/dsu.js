var dsu = "https://ohmage-omh.smalldata.io/dsu/";

function getSummaryDatapointId(username, date, device){
    return  ["mobility-daily-summary", username, date, device.toLowerCase()].join("-");
}
