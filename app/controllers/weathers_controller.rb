class WeathersController < ApplicationController

  def index
    result = Weathers::List.new(list_params).call

    if result.success?
      weathers = result.success
      render json: weathers, include: ['location'], status: :ok
    else
      render json: result.failure, status: :not_found
    end
  end

  def create
    result = Weathers::Create.new.call(create_params)

    if result.success?
      render json: result.success, status: :created
    else
      render json: result.failure, status: :bad_request
    end
  end

  def destroy
    Weathers::Erase.new(delete_params).call

    render json: {}, status: :ok
  end

  private

  def create_params
    params.permit(:id, :date, temperature: [], location: [:lat, :lon, :city, :state])
  end

  def delete_params
    params.permit(*Weathers::Erase::ERASE_KEYS)
  end

  def list_params
    params.permit(:date, :lat, :lon)
  end
end
