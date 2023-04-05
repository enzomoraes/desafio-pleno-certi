import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UserCreate, UserModel } from '../core/model';
@Injectable({
  providedIn: 'root',
})
export class UsersService {
  private route: string = '/users';
  private host = environment.apiHost;

  constructor(private http: HttpClient) {}

  /**
   * This methods calls the api in order to bring all users
   * @param orderDirection that we want te results to be
   * @returns an array of UserModel
   */
  findAll(orderDirection: -1 | 1 = -1): Observable<UserModel[]> {
    return this.http.get<UserModel[]>(
      `${this.host}${this.route}?orderDirection=${orderDirection}`
    );
  }

  /**
   * This methods calls the api in order to bring a single user
   * @param orderDirection that we want te results to be
   * @returns an array of UserModel
   */
  findOne(id: string): Observable<UserModel> {
    return this.http.get<UserModel>(`${this.host}${this.route}/${id}`);
  }

  /**
   * This method calls the api in order to create an user
   * @param userCreate object dto
   * @returns UserModel
   */
  create(userCreate: UserCreate): Observable<UserModel> {
    return this.http.post<UserModel>(`${this.host}${this.route}`, userCreate);
  }
  
  /**
   * This method calls the api in order to create an user
   * @param userCreate  object dto
   * @returns UserModel
   */
  update(userCreate: UserCreate): Observable<UserModel> {
    return this.http.put<UserModel>(`${this.host}${this.route}`, userCreate);
  }
}
