import Sortable from 'sortablejs';
import Rails from "@rails/ujs"; //for Rails AJAX

const initKanbanSortable = (ulElements) => {
    const saveKanbanBinded = saveKanban.bind(null, ulElements)
    ulElements.forEach((ul) => {
        new Sortable(ul, {
            group: 'kanban', //groups kanban cols to allow swapping between cols
            animation: 300,
            onEnd: saveKanbanBinded //calls saveKanbanBinded after element is dragged
        })
    })
}

//const kanbanForm = document.querySelector(".kanban-form-input") //puts the form in a variable to be sent form input value later
// Let's build an Object kanbanIds containing all the kanban Ids
// E.g. :
// {
//   "columns": [
//     { "id": 1, "itemIds": [3, 2] },
//     { "id": 2, "itemIds": [4, 5] },
//     { "id": 3, "itemIds": [6, 1] }
//   ]
// }
const saveKanban = (ulElements) => {
    const kanbanIds = {"columns": []}
    ulElements.forEach(ul => {
        const itemIds = []
        let array = ul.querySelectorAll(".kanban-col-item")
        array.forEach(item => itemIds.push(Number.parseInt(item.dataset.itemId, 10)))

        kanbanIds.columns.push({
            'id': Number.parseInt(ul.dataset.colId,10),
            'itemIds': itemIds
        })
    })
    //kanbanForm.value = JSON.stringify(kanbanIds) //sets the value of the form input as a json object containing the order of cards in each col
    const kanbanId = document.querySelector('.kanban').dataset.id
    const formData = new FormData()
    formData.append('kanban[kanbanIds]', JSON.stringify(kanbanIds)) //sets the value of the form input as a json object containing the order of cards in each col
    Rails.ajax({
        url: `/kanbans/${kanbanId}/sort`,
        type: "patch",
        data: formData
    })
}

export { initKanbanSortable }