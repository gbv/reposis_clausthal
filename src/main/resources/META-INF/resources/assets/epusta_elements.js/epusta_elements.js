//Class ePuStaInline

class ePuStaInline {
  constructor (element,providerurl,epustaid,from,until,tagquery) {
    this.providerurl = providerurl;
    this.epustaid = epustaid;
    this.$element = $(element);
    this.count = "";
    this.tagquery = tagquery;
    this.state = "";
    this.errortext ="";
    this.from = (isNaN(Date.parse(from)) === false) ? from : "2010-01-01";
    this.until = (isNaN(Date.parse(until)) === false) ? until : new Date().toJSON().substring(0,10);
    this._granularity = "total";
  }

  async requestData() {
    this.state="waiting";
    this.render();
    $.ajax({
      method : "GET",
      url : this.providerurl
        + "/statistics?identifier="+this.epustaid
        + "&start_date=" + this.from + "&end_date=" + this.until
        + "&granularity=" + this._granularity
        + "&tagquery=" + this.tagquery,
      dataType : "json",
      context: this
      }).done(function(data) {
        ePuStaInline.receiveData(this, data);
      }).fail(function(e) {
        this.state="error";
        this.errortext="Fehler beim Holen der Daten vom Graphprovider";
        this.render();
    });
  }

  render() {
    switch(this.state) {
      case "error":
        this.$element.html("<i class='fas fa-exclamation-triangle' data-toggle='tooltip' title='"+this.errortext+"'></i>");
        break;
      case "waiting":
        this.$element.html("<i class='fas fa-spinner fa-pulse'></i>");
        break;
      case "success":
        this.$element.text(this.count);
        break;
      default:
        this.$element.text("");
    }
  }

  setCount(count) {
    this.count=count;
  }

  getCounttype(counttype) {
    return(this.counttype);
  }
};

ePuStaInline.receiveData = function(epustainline,json) {

  if (json) {
    var count=json.statistics.total;
    epustainline.setCount(count);
  } else {
    // JSON Loader does not reponse xml if the ID doesn't exsist or never counted
    epustainline.setCount(0);
  }
  epustainline.state="success";
  epustainline.render();
};

//Class ePuStaGraph

class ePuStaGraph {
  constructor (element,providerurl,epustaid,from,until,tagquery,granularity) {
    this.providerurl = providerurl;
    this.epustaid = epustaid;
    this.element = element;
    this.element.epustagraph = this;
    this.$element = $(element);
    this.state = "";
    this.errortext ="";
    this._granularity = granularity;
    this.tagquery = tagquery;
    this.from = (isNaN(Date.parse(from)) === false) ? from : "auto";
    this.until = (isNaN(Date.parse(until)) === false) ? until : new Date().toJSON().substring(0,10);
    this.data = [];
    this.barchart = null;
  }
  
  async requestData() {
    if (this._granularity == 'total') {
      this.state="error";
      this.errortext="Granularity total selected";
      this.render(); 
    } else {
    
      this.state="waiting";
      this.render();
      var from = this.calculateFrom();
      var until = this.calculateUntil();
      
      $.ajax({
        method : "GET",
        url : this.providerurl
          + "/statistics?identifier="+this.epustaid
          + "&start_date=" + from + "&end_date=" + until
          + "&granularity="+this._granularity
          + "&tagquery="+this.tagquery,
        dataType : "json",
        context: this
        }).done(function(data) {
          ePuStaGraph.receiveData(this, data);
        }).fail(function(e) {
          this.state="error";
          this.errortext="Error during geting data";
          this.render();
      });
    }
  }

  render() {
    switch(this.state) {
      case "error":
        var html='<div style="with:100%;text-align:center;">';
        html+="<i class='fas fa-exclamation-triangle' data-toggle='tooltip' title='"+this.errortext+"'/>";
        html+=this.errortext;
        html+="</div>";
        this.$element.html(html);
        break;
      case "waiting":
        this.$element.html("<div style='font-size: 5em;text-align:center;'> <i class='fas fa-spinner fa-pulse'></i> </div>");
        break;
      case "success":
        //this.$element.html(" <div id='epustaGraphic' style='height:80%'> </div> ");
        //var epustaElement = this;
        this.canvas = document.createElement("canvas");
        this.element.replaceChildren(this.canvas); 
        var data;
        switch (this._granularity) {
          case 'day':
            data=this.data.day;
            break;
          case 'week':
            data=this.data.week;
            break;
          case 'month':
            data=this.data.month;
            break;
          case 'year':
            data=this.data.year;
            break;
        }
        
        var count_data = data.map( x => x.count );  
        var labels_data = data.map (  x => x.date );

        if (this.barchart) this.barchart.destroy();

        this.barchart = new Chart(this.canvas, {
          type: 'bar',
          data: {
            labels: labels_data,
            datasets: [{
              label: 'Volltextzugriffe',
              data: count_data,
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
          //  scales: {
          //    y: {
          //      beginAtZero: true
          //    }
          //  }
          }
        });

        break;
      default:
        this.$element.text("");
    }
  }

  calculateFrom() {
	var today=new Date();
    
    if (this.from === "auto") {
      var from=new Date();
      switch (this._granularity) {
        case "day":
          from.setDate(today.getDate() - 30);
          break;
        case "week":
          from.setDate(today.getDate() - 77);
          break;
        case "month":
          from.setMonth(today.getMonth() - 11);
          break;
        case "year":
          from.setFullYear(today.getFullYear() - 9);
          break;
      }
    } else {
      var from=new Date(this.from);
    }
    switch (this._granularity) {
      case "month":
        from = new Date (from.getFullYear(), from.getMonth() , 1);
        break;
      case "year":
          from = new Date (from.getFullYear(), 0, 1);
          break;
    }
    return from.getFullYear() + '-' + (from.getMonth()+1).toString().padStart(2, "0") + '-' + from.getDate().toString().padStart(2, "0");
  }
  
  calculateUntil() {
    var until=new Date(this.until);
    switch (this._granularity) {
      case "month":
        until = new Date (until.getFullYear(), until.getMonth()+1, 0);
        break;
      case "year":
        until = new Date (until.getFullYear(), 11, 31);
        break;
    }
    return until.getFullYear() + '-' + (until.getMonth()+1).toString().padStart(2, "0") + '-' + until.getDate().toString().padStart(2, "0");
  }
  
};

ePuStaGraph.receiveData = function(epustagraph,json) {
  if (json) {
    epustagraph.data=json.statistics;
    epustagraph.state="success";
  } else {
    epustagraph.state="error";
    epustagraph.errortext="No data received";
  }
  epustagraph.render();
};

// End Class ePuStaGraph

document.addEventListener('DOMContentLoaded', function () {
  $('[data-epustaelementtype]').each(function(index, element) {
    var epustaElementtype=$(element).data('epustaelementtype');
    var epustaProviderurl=$(element).data('epustaproviderurl');
    var epustaIdentifier=$(element).data('epustaidentifier');
    var epustaTagQuery = "";
    // For backward compatibility
    var epustaCounttype=$(element).data('epustacounttype');
    if (epustaCounttype == "counter") {
    	epustaTagQuery = "-epusta:filter:httpMethod -epusta:filter:httpStatus -filter:30sek:counter3 -filter:robot oas:content:counter"
    } else if (epustaCounttype == "counter_abstract") {
    	epustaTagQuery = "-epusta:filter:httpMethod -epusta:filter:httpStatus -filter:30sek:counter3 -filter:robot oas:content:counter_abstract"
    }
    // End
    if ($(element).data('epusttagquery')) epustaTagQuery = $(element).data('epustatagquery');
    var epustaFrom=$(element).data('epustafrom');
    var epustaUntil=$(element).data('epustauntil');
    var epustaGranularity=$(element).data('epustagranularity');
    var epustaElement;
    if (epustaElementtype === "ePuStaInline" ) {
      epustaElement = new ePuStaInline(element,epustaProviderurl,epustaIdentifier,epustaFrom,epustaUntil,epustaTagQuery);
      epustaElement.requestData();
    }
    if (epustaElementtype === "ePuStaGraph" ) {
      epustaElement = new ePuStaGraph(element,epustaProviderurl,epustaIdentifier,epustaFrom,epustaUntil,epustaTagQuery,epustaGranularity);
      epustaElement.requestData();
    }
  });
});

export {ePuStaGraph, ePuStaInline};