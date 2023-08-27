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
function editUserForm(user) {
    popupContainer = document.getElementById("popupContainer");
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/school_staff/update" method="post">
          <input type="hidden" name="key" value=${JSON.stringify(user['CF'])}>
          <input type="hidden" name="type" value="not_student"}>
	      <input type="text" name="name" disabled placeholder="Name" value=${JSON.stringify(user['name'])}>
          <input type="text" name="surname" disabled placeholder="Surname" value=${JSON.stringify(user['surname'])}>
          <input type="text" name="CF1" disabled placeholder="CF1" value=${JSON.stringify(user['CF1'])}>
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
function editStudentForm(student,classes) {
    console.log(JSON.stringify(classes));
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
          <input type="text" name="CF1" disabled placeholder="CF1" value=${JSON.stringify(student['CF1'])}>
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
    popupContainer = document.getElementById("popupContainer");
    popupContainer.innerHTML = `
      <div class="popupMenu">

          <div id="closePopup">&times;</div>      
          <form action="/school_staff/editClass" method="post">
          <input type="hidden" name="key" value=${CF}>
          <input type="hidden" name="old_class" value=${JSON.stringify(cls['class_code'])}>
	      <input type="text" name="new_class" placeholder="Class" value=${JSON.stringify(cls['class_code'])}>


        <table>
        <tr>
          <th>Name</th>
          <th>Surname</th>
          <th>CF</th>
        </tr>
        ${stud.map(s => `
          <tr>
            <td>${s.name}</td>
            <td>${s.surname}</td>
            <td>${s.CF}</td>
            <td>
              <form action="/school_staff/removeStudent" method="post">
                <input type="hidden" name="CF" value=${CF}>
                <input type="hidden" name="stud" value=${s.CF}>
                <input type="submit" value="Delete student">
              </form>
            </td>
          </tr>
        `).join('')}
      </table>
      
<br>
          <input class="submitBtn" type="submit" value="Update Class Name">        
        </form>
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
        <form action="/school_staff/editClass" method="post">
        <input type="hidden" name="CF" value=${CF}>
        <input type="hidden" name="old_class" value=${JSON.stringify(cls['class_code'])}>
      <input type="text" name="new_class" placeholder="Class" value=${JSON.stringify(cls['class_code'])}>


      <table>
      <tr>
        <th>Name</th>
        <th>Surname</th>
        <th>CF</th>
      </tr>
      ${stud.map(s => `
        <tr>
          <td>${s.name}</td>
          <td>${s.surname}</td>
          <td>${s.CF}</td>
          <td>
            <form action="/school_staff/removeStudent" method="post">
              <input type="hidden" name="CF" value=${CF}>
              <input type="hidden" name="stud" value=${s.CF}>
              <input type="submit" value="Delete student">
            </form>
          </td>
        </tr>
      `).join('')}
    </table>
    
<br>
        <input class="submitBtn" type="submit" value="Update Class Name">        
      </form>
  </div>
  `;  
  document.querySelector("#closePopup").addEventListener("click", function() {
  popupContainer.innerHTML = "";
  });
}