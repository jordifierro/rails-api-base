module Api
  module V1
    class NotesController < ApiController
      def index
        render json: current_user.notes.all
      end

      def show
        render json: current_user.notes.find(params[:id])
      end

      def create
        note = current_user.notes.new(note_params)
        if note.save
          render json: note, status: :created
        else
          render_error(note.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        note = current_user.notes.find(params[:id])
        if note.update(note_params)
          render json: note
        else
          render_error(note.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def destroy
        note = current_user.notes.find(params[:id])
        note.destroy
        head :no_content
      end

      private

      def note_params
        params.require(:note).permit(:title, :content)
      end
    end
  end
end
