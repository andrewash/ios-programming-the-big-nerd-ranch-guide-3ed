var fileReader;

// var RAILS_ROOT_URL = 'http://localhost:3000';
// var NODE_ROOT_URL  = 'http://localhost:8080';
var RAILS_ROOT_URL = 'http://app01.c45991.blueboxgrid.com';
var NODE_ROOT_URL  = 'http://app01.c45991.blueboxgrid.com'; // must not include subdirectory in this URL, see 

window.addEventListener("load", Ready);

// Background: the FileReader class allows us to open and read parts of a file, 
//  and pass the data as a Binary string to the server.

function Ready(){
  if(window.File && window.FileReader){ // These are the relevant HTML5 objects we are going to use
    document.getElementById('UploadButton').addEventListener('click', StartUpload);
    document.getElementById('FileBox').addEventListener('change', FileChosen);
    
    var socket = io.connect(NODE_ROOT_URL, PassQueryToSocket());
    // var socket = io.connect('http://localhost:8080', PassQueryToSocket());
  }
  else {
    document.getElementById('UploadArea').innerHTML = "Your Browser Doesn't Support The File API. Please Update Your Browser.";
  }

  // sets a global variable with the file – so that we can access it later
  // fills in the name field, so that the user has a reference point when naming the file. 
  var SelectedFile;
  var fileReader;

  function PassQueryToSocket() {
    var result = "";
    result += "model=" + getModel();
    result += "&media_type=" + getMediaType();
    result += "&model_id=" + getModelID();
    var jsonResult = { resource: 'nodejs/socket.io', query: result };
    return jsonResult;
  }

  function getModel() { return document.getElementById('query-model').innerText; }
  function getMediaType() { return document.getElementById('query-media_type').innerText; }
  function getModelID() { return document.getElementById('query-model_id').innerText; }

  function FileChosen(evnt) {
    SelectedFile = evnt.target.files[0];
    // document.getElementById('TitleBox').value = SelectedFile.name;
  }

  function StartUpload()
  {
    if (document.getElementById('FileBox').value != "") // validate: they've chosen a file to upload
    {
      fileReader = new FileReader();
      var uploadAreaHTML = "";
      uploadAreaHTML += "<span id='NameArea'>Uploading " + SelectedFile.name + "</span>";
      uploadAreaHTML += "<div id='ProgressContainer'><div id='ProgressBar'></div></div>";
      uploadAreaHTML += "<span id='percent'>0%</span>";
      uploadAreaHTML += "<span id='Uploaded'> - <span id='MB'>0</span> / " + Math.round(SelectedFile.size / (1024*1024)) + "MB</span>";
      document.getElementById('UploadArea').innerHTML = uploadAreaHTML;
      fileReader.onload = function(evnt) {
        console.log( { 'model_id': getModelID(), 
                       'FileSegment': evnt.target.result} );
        socket.emit('Upload', { 'FileSegment': evnt.target.result });
      }
      socket.emit('Start', { 'Filename': SelectedFile.name, 'Size': SelectedFile.size });
    }
    else
    {
      alert("Please select a file");
    }
  }

  socket.on('MoreData', function(data) {
    UpdateBar(data['Percent']);
    var bookmark = data['Bookmark'] * 524288;  // the next block's starting position
    var nextBlockToUpload;  // the first segment of the upload file that we have _not_ uploaded.
    if (SelectedFile.slice) {   // for Cross-Browser support for slicing a file into segments, see http://caniuse.com/filereader
      nextBlockToUpload = SelectedFile.slice(bookmark, bookmark + Math.min(524288, SelectedFile.size-bookmark));
    }
    fileReader.readAsBinaryString(nextBlockToUpload);
  });

  function UpdateBar(percent) {
    document.getElementById('ProgressBar').style.width = percent + '%';
    document.getElementById('percent').innerHTML = (Math.round(percent*100) / 100) + '%';
    var mbUploaded = Math.round(((percent/100.0) * SelectedFile.size) / (1024*1024));
    document.getElementById('MB').innerHTML = mbUploaded;
  }

  socket.on('Done', function(data) {
    var rootURL = NODE_ROOT_URL + '/';
    var uploadAreaHTML = "";
    uploadAreaHTML += "We've received your new video!";
    uploadAreaHTML += "<p>Please wait a few minutes before sharing this exercise. We'll process this video in the background, so you can keep doing your work.</p>";
    uploadAreaHTML += "<br/><br/>"
    uploadAreaHTML += "<button type='button' name='Add another exercise' value='' id='Restart' class='Button'>Add another exercise</button>";
    document.getElementById('UploadArea').innerHTML = uploadAreaHTML;
    document.getElementById('Restart').addEventListener('click', Refresh);
  });

  function Refresh() {
    location.replace(RAILS_ROOT_URL + "/exercises/new");
  }

} // - Ready()