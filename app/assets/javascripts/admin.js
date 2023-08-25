/*  ########################################################
    #           Script per Utente Admin                    #
    ########################################################
*/    
// Funzione per switchare il pannello tra schoolstaff e school
function show_panel(id){
    if(id=="first-panel"){
        document.getElementById(id).style.display="flex";
        document.getElementById("second-panel").style.display="none";
    }
    else{
        document.getElementById(id).style.display="flex";
        document.getElementById("first-panel").style.display="none";

    }
}

// Funzione per aprire popup per creare scuola
function openSchoolForm() {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/admin/createSchool" method="post">
          <input type="text" name="address" placeholder="Address">
          <input type="text" name="name" placeholder="Name">
          <input type="text" name="code" placeholder="code">
          <input type="text" name="school_type" placeholder="School Type">
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}

function editStaffForm(staff) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/admin/updateStaff" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(staff['CF'])}>
	      <input type="text" name="name" placeholder="Name" value=${JSON.stringify(staff['name'])}>
          <input type="text" name="surname" placeholder="Surname" value=${JSON.stringify(staff['surname'])}>
          <input type="text" name="CF" placeholder="CF" value=${JSON.stringify(staff['CF'])}>
          <input type="email" name="mail" placeholder="Mail" value=${JSON.stringify(staff['mail'])}>
          <input type="password" name="password" placeholder="Password" value=${JSON.stringify(staff['password'])}>
          <input type="text" name="school_code" placeholder="School Code" value=${JSON.stringify(staff['school_code'])}>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}


// Funzione per aprire popup per creare schoolstaff
function openStaffForm() {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/admin/createStaff" method="post">
          <input type="text" name="name" placeholder="Name">
          <input type="text" name="surname" placeholder="Surname">
          <input type="text" name="CF" placeholder="CF">
          <input type="email" name="mail" placeholder="Mail">
          <input type="password" name="password" placeholder="Password">
          <input type="text" name="school_code" placeholder="School Code">
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}

function editSchoolForm(school) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/admin/updateSchool" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(school['code'])}>
          <input type="text" name="address" placeholder="Address" value=${JSON.stringify(school['address'])}>
          <input type="text" name="name" placeholder="Name" value=${JSON.stringify(school['name'])}>
          <input type="text" name="code" placeholder="code" value=${JSON.stringify(school['code'])}>
          <input type="text" name="school_type" placeholder="School Type" value=${JSON.stringify(school['school_type'])}>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}