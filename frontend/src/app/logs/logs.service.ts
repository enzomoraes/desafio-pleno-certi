import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { LogModel } from '../core/model';

@Injectable({
  providedIn: 'root',
})
export class LogsService {
  private route: string = '/logs';
  private host = environment.apiLogsHost;

  constructor(private http: HttpClient) {}

  /**
   * This methods calls the api in order to bring all logs
   * @param orderDirection that we want te results to be
   * @returns an array of LogModel
   */
  findAll(orderDirection: -1 | 1 = -1): Observable<LogModel[]> {
    return this.http.get<LogModel[]>(
      `${this.host}${this.route}?orderDirection=${orderDirection}`
    );
  }

  /**
   * This methods calls the api in order to bring a single log
   * @param orderDirection that we want te results to be
   * @returns an array of LogModel
   */
  findOne(id: string): Observable<LogModel> {
    return this.http.get<LogModel>(`${this.host}${this.route}/${id}`);
  }
}
