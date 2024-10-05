from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TodoItem(BaseModel):
    id: int
    title: str
    description: str = None
    completed: bool = False

todo_list = []

@app.post("/todos/", response_model=TodoItem)
def create_todo_item(todo: TodoItem):
    todo_list.append(todo)
    return todo

@app.get("/todos/", response_model=List[TodoItem])
def get_todo_items():
    return todo_list

@app.get("/todos/{todo_id}", response_model=TodoItem)
def get_todo_item(todo_id: int):
    todo = next((item for item in todo_list if item.id == todo_id), None)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    return todo

@app.put("/todos/{todo_id}", response_model=TodoItem)
def update_todo_item(todo_id: int, updated_todo: TodoItem):
    index = next((index for (index, d) in enumerate(todo_list) if d.id == todo_id), None)
    if index is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    todo_list[index] = updated_todo
    return updated_todo

@app.delete("/todos/{todo_id}", response_model=TodoItem)
def delete_todo_item(todo_id: int):
    index = next((index for (index, d) in enumerate(todo_list) if d.id == todo_id), None)
    if index is None:
        raise HTTPException(status_code=404, detail="Todo item not found")
    return todo_list.pop(index)
