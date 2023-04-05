export interface UserModel {
  _id: string;
  name: string;
  login: string;
  timestamp: number;
}

export interface UserCreate {
  name: string;
  login: string;
  timestamp: number;
}

export interface LogModel {
  action: string;
  payload: any;
  timestamp: number;
}
