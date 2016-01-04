class Api::V1::NotesController < ApplicationController

  def index
    render Note.all
  end

  def show
    render Note.find(params[:id])
  end

  def create
    note = Note.create(note_params)
    render note
  end

  def update
    note = Note.update(params[:id], note_params)
    render note
  end

  def destroy
    note = Note.find(params[:id])
    note.destroy
    head 204
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end

end
