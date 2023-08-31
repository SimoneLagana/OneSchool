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

          <div id="closePopup-admin">&times;</div>
          <label>Insert school</label>      
          <form action="/admin/createSchool" class="create-form" method="post">
          <input type="text" name="address" class="text-field" placeholder="Address">
          <input type="text" name="name" class="text-field" placeholder="Name">
          <input type="text" name="code" class="text-field" placeholder="code">
          <input type="text" name="school_type" class="text-field" placeholder="School Type">
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup-admin").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}

function editStaffForm(staff) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup-admin">&times;</div>
          <label>Edit school staff</label>   
          <form action="/admin/updateStaff" class="create-form" method="post">
          <input type="hidden" name="key" class="text-field" value=${JSON.stringify(staff['CF'])}>
	      <input type="text" name="name" class="text-field" placeholder="Name" value=${JSON.stringify(staff['name'])}>
          <input type="text" name="surname" class="text-field" placeholder="Surname" value=${JSON.stringify(staff['surname'])}>
          <input type="text" name="CF" class="text-field" placeholder="CF" disabled value=${JSON.stringify(staff['CF'])}>
          <input type="email" name="mail" class="text-field" placeholder="Mail" value=${JSON.stringify(staff['mail'])}>
          <input type="password" name="password" class="text-field" placeholder="Password" value=${JSON.stringify(staff['password'])}>
          <input type="text" name="school_code" class="text-field" placeholder="School Code" value=${JSON.stringify(staff['school_code'])}>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup-admin").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}


// Funzione per aprire popup per creare schoolstaff
function openStaffForm() {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup-admin">&times;</div>
          <label>Insert school staff</label>      
          <form action="/admin/createStaff" class="create-form" method="post">
          <input type="text" name="name" class="text-field" placeholder="Name">
          <input type="text" name="surname" class="text-field" placeholder="Surname">
          <input type="text" name="CF" class="text-field" placeholder="CF">
          <input type="email" name="mail" class="text-field" placeholder="Mail">
          <input type="password" name="password" class="text-field" placeholder="Password">
          <input type="text" name="school_code" class="text-field" placeholder="School Code">
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup-admin").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}

function editSchoolForm(school) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup-admin">&times;</div>
          <label>Edit school</label> 
          <form action="/admin/updateSchool" class="create-form" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(school['code'])}>
          <input type="text" name="address" class="text-field" placeholder="Address" value=${JSON.stringify(school['address'])}>
          <input type="text" name="name" class="text-field" placeholder="Name" value=${JSON.stringify(school['name'])}>
          <input type="text" name="code" class="text-field" placeholder="code" disabled value=${JSON.stringify(school['code'])}>
          <input type="text" name="school_type" class="text-field" placeholder="School Type" value=${JSON.stringify(school['school_type'])}>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup-admin").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}


function editpassword(CF, email) {
    popupcontainer = document.getElementById("popupcontainer");
  
    popupcontainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">&times;</div>
          <form action="/admin/changepassword" method="post">
            <input type="text" id="CF" name="CF" hidden value=${CF}>
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value=${email}><br>

            <label for="old_password">Insert old password</label>
            <input type="password" id="old_password" name="old_password" required><br>
            <label for="password">Insert new password</label>
            <input type="password" id="password" name="password" required><br>
            <input type="submit" value="Submit">
          </form>
      </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupcontainer.innerHTML = "";
    });
}