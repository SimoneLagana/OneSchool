function print() {
  console.log("bbbb")
}


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

function editUserForm(user,CF) {
  
    popupContainer = document.getElementById("popupContainer");
    popupContainer.innerHTML = `
      <div class="popupMenu">
  
          <div id="closePopup">&times;</div>      
          <form action="/school_staff/update" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(user['CF'])}>
          <input type="hidden" name="type" value="not_student"}>
	      <input type="text" name="name" disabled placeholder="Name" value=${JSON.stringify(user['name'])}>
          <input type="text" name="surname" disabled placeholder="Surname" value=${JSON.stringify(user['surname'])}>
          <input type="text" name="CF1" disabled placeholder="CF1" value=${JSON.stringify(user['CF'])}>
          <input type="email" name="mail" placeholder="Mail" value=${JSON.stringify(user['mail'])}>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}
function editStudentForm(student,classes,CF) {
    
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/school_staff/update" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(student['CF'])}>
          <input type="hidden" name="type" value="student"}>
          <input type="hidden" name="old_class" value=${student['student_class_code']}>
	      <input type="text" name="name" disabled placeholder="Name" value=${JSON.stringify(student['name'])}>
          <input type="text" name="surname" disabled placeholder="Surname" value=${JSON.stringify(student['surname'])}>
          <input type="text" name="CF1" disabled placeholder="CF1" value=${JSON.stringify(student['CF'])}>
          <input type="text" name="birthdate" disabled placeholder="birthdate" value=${JSON.stringify(student['birthdate'])}>
          <input type="email" name="mail" placeholder="Mail" value=${JSON.stringify(student['mail'])}>
          <select name="class">
          ${classes.map(cls => `<option value="${cls}" ${cls === student['student_class_code'] ? 'selected' : ''}>${cls}</option>`).join('')}
          </select>
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}
function editClassForm(cls,CF,stud,classes) {
    console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    popupContainer = document.getElementById("popupContainer");
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/school_staff/editClass" method="post">
          <input type="hidden" name="key" value=${CF}>
          <input type="hidden" name="old_class" value=${JSON.stringify(cls['class_code'])}>
	      <input type="text" name="new_class" placeholder="Class" value=${JSON.stringify(cls['class_code'])}>
          <input class="submitBtn" type="submit" value="Update Class Name">        
        </form>
        <div id="manageAdminTableDiv-small">

        <table >
        <tr>
          <th>Name</th>
          <th>Surname</th>
          <th>CF</th>
        </tr>
        ${stud.map(s => `
        <tr>
          <td class="center">${s.name}</td>
          <td class="center">${s.surname}</td>
          <td class= "center">${s.CF}</td>
          <td>
            <form action="/school_staff/removeStudent" method="post">
              <input type="hidden" name="CF" value=${CF}>
              <input type="hidden" name="stud" value=${s.CF}>
              <input type="submit" value="Remove student" class="style-button-small">
            </form>
          </td>
        </tr>
      `).join('')}
      </table>
      
<br>
</div>
    </div>
    `;  
    document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
    });
}
function openAddClassForm(CF) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">×</div>      
        <form id="addClassForm" action="/school_staff/addClass" method="post">
          <input type="hidden" name="CF" value=${CF}>
          <input type="text" id="classCodeInput" name="class_code" placeholder="Class Code">
          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
      </div>
    `;
     document.querySelector("#closePopup").addEventListener("click", function() {
      popupContainer.innerHTML = "";
    }); 
  }

function openAddSubjectForm(CF) {
    popupContainer = document.getElementById("popupContainer");
  
    popupContainer.innerHTML = `
      <div class="popupMenu">
        <div id="closePopup">×</div>      
        <form id="addClassForm" action="/school_staff/addSubject" method="post">
          <input type="hidden" name="CF" value=${CF}>
          <input type="text"  name="subject_name" placeholder="Name">
          <input type="text"  name="subject_class" placeholder="Class">
          <input type="text"  name="subject_teacher" placeholder="Teacher CF">
          <select name="subject_day">
            <option selected> Monday </option>
            <option> Tuesday </option>
            <option> Wednesday </option>
            <option>Thursday </option>
            <option> Friday </option>
            <option> Saturday </option>
          </select>
          <select name="subject_hour">
          <option selected> 1 </option>
          <option> 2 </option>
          <option> 3 </option>
          <option>4 </option>
          <option> 5 </option>
          <option> 6 </option>
        </select>

          <br>
          <input class="submitBtn" type="submit" value="submit">
        </form>
      </div>
    `;
     document.querySelector("#closePopup").addEventListener("click", function() {
      popupContainer.innerHTML = "";
    }); 
}
function editSubjectForm(subj, CF) {
  popupContainer = document.getElementById("popupContainer");
  popupContainer.innerHTML = `
    <div class="popupMenu">

        <div id="closePopup">&times;</div>      
        <form action="/school_staff/editSubject" method="post">
        <input type="hidden" name="CF" value=${CF}>
        <input type="hidden" name="subj_name" value=${subj[0][0]}>
        <input type="hidden" name="subj_old_teacher" value=${subj[0][2]}>
        <input type="hidden" name="subj_class"   value=${JSON.stringify(subj[0][1])}>
        <input type="text" disabled name="subj_name" value=${subj[0][0]}>

        <input type="text" name="subj_classsss"  disabled value=${JSON.stringify(subj[0][1])}>
        <input type="text" name="subj_new_teacher"  value=${JSON.stringify(subj[0][2])}>
        <input class="submitBtn" type="submit" value="Update Teacher">        
      </form>
      <div id="manageAdminTableDiv-small">
        <table>
      <thead>
        <tr>
          <th>Weekday</th>
          <th>Hour</th>
          <th colspan="3"></th>
        </tr>
      </thead>

     <tbody>
      ${subj.map(s => `
        <tr>
          <td class="center">${s[3]}</td>
          <td class="center">${s[4]}</td>
          <td class="center">
          <form action="/school_staff/subjectDelete" method="post">
          <input type="hidden" name="CF" value=${CF}>
          <input type="hidden" name="subj_name" value=${s[0]}>
          <input type="hidden" name="subj_class" value=${s[1]}>
          <input type="hidden" name="subj_teacher" value=${s[2]}>
          <input type="hidden" name="subj_day" value=${s[3]}>
          <input type="hidden" name="subj_time" value=${s[4]}>
          <input type="submit" value="Delete Hour">
        </form>
          </td>
        </tr>
      `).join('')}
      </tbody>
    </table>
    
<br>

  </div>
  `;  
  document.querySelector("#closePopup").addEventListener("click", function() {
  popupContainer.innerHTML = "";
  });
}
function openCommunicationForm(CF) {
  popupContainer = document.getElementById("popupContainer");

  popupContainer.innerHTML = `
    <div class="popupMenu-large">
      <div id="closePopup">×</div>
      <form action="/school_staff/addCommunication" method="post">
        <input type="hidden" name="CF" value=${CF}>
        <input type="text" name="title" placeholder="Insert title"><br><br>
        <input type="date" name="date"><br><br>
        <textarea name="text" placeholder="Insert text for new communication" rows="10" cols="50"></textarea>
        <br><br>
        <input class="submitBtn" type="submit" value="Submit communication">
      </form>
    </div>
  `;
  document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
  });
}
function viewComunication(title,msg, date) {
  popupContainer = document.getElementById("popupContainer");

  popupContainer.innerHTML = `
    <div class="popupMenu">
      <div id="closePopup">×</div>
      <h>${title}</h>
      <br>       
      created at: ${date}
        <br>
      ${msg}
        <br>

    </div>
  `;
  document.querySelector("#closePopup").addEventListener("click", function() {
    popupContainer.innerHTML = "";
  });
}


function editpassword(CF, email) {
  popupcontainer = document.getElementById("popupcontainer");

  popupcontainer.innerHTML = `
    <div class="popupMenu">
      <div id="closePopup">&times;</div>
        <form action="/school_staff/changepassword" method="post">
          <input type="hidden" id="CF" name="CF"  value=${CF}>
          <label for="email">Email:</label>
          <br>
          <input type="email" id="email" name="email" value=${email}><br>

          <label for="old_password">Inserisci vecchia password:</label><br>
          <input type="password" id="old_password" name="old_password" required><br>
          <label for="password">Inserisci nuova password:</label><br>
          <input type="password" id="password" name="password" required><br>
          <input type="submit" class="submitBtn"value="Submit">
        </form>
    </div>
  `;  
  document.querySelector("#closePopup").addEventListener("click", function() {
  popupcontainer.innerHTML = "";
  });
}