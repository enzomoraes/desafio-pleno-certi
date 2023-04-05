import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subject, takeUntil } from 'rxjs';
import { LogModel } from 'src/app/core/model';
import { LogsService } from '../logs.service';

@Component({
  selector: 'app-details',
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.scss'],
})
export class DetailsComponent implements OnInit {
  private terminator$: Subject<boolean> = new Subject();

  public currentLogId: string;
  public currentLog: LogModel;

  constructor(
    private logsService: LogsService,
    private route: ActivatedRoute
  ) {}

  /**
   * Calling this method to terminate all subscriptions
   */
  ngOnDestroy(): void {
    this.terminator$.next(true);
    this.terminator$.complete();
  }

  ngOnInit(): void {
    this.currentLogId = this.route.snapshot.queryParams['id'];

    this.logsService
      .findOne(this.currentLogId)
      .pipe(takeUntil(this.terminator$))
      .subscribe((log) => {
        this.currentLog = log;
      });
  }
}
