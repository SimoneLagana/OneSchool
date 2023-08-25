var panel = "manage"
function show_panel(id){
    if(id=="first-panel"){
        document.getElementById(id).style.display="flex";
        document.getElementById("second-panel").style.display="none";
        panel = "manage"
    }
    else{
        document.getElementById(id).style.display="flex";
        document.getElementById("first-panel").style.display="none";
        panel="insert"

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
          <input type="text" name="CF" disabled placeholder="CF" value=${JSON.stringify(user['CF'])}>
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
          <input type="text" name="CF" disabled placeholder="CF" value=${JSON.stringify(student['CF'])}>
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