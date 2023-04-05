import { Component, ViewChild } from '@angular/core';
import { Sort } from '@angular/material/sort';
import { Subject, takeUntil } from 'rxjs';
import { LogModel } from 'src/app/core/model';
import { DetailsComponent } from '../details/details.component';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { LogsService } from '../logs.service';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent {
  @ViewChild(MatPaginator) paginator: MatPaginator;

  public displayedColumns: string[] = ['action', 'timestamp', 'actions'];
  public dataSource: MatTableDataSource<LogModel> = new MatTableDataSource();

  private terminator$: Subject<boolean> = new Subject();

  constructor(
    private logsService: LogsService,
    private route: ActivatedRoute,
    private router: Router,
    public dialog: MatDialog
  ) {}

  /**
   * Calling this method to terminate all subscriptions
   */
  ngOnDestroy(): void {
    this.terminator$.next(true);
    this.terminator$.complete();
  }

  ngOnInit(): void {
    this.logsService
      .findAll()
      .pipe(takeUntil(this.terminator$))
      .subscribe((result) => this.updateTable(result));

    this.route.queryParams
      .pipe(takeUntil(this.terminator$))
      .subscribe((params: Params) => {
        if (params['id']) {
          this.dialog
            .open(DetailsComponent, { width: 'auto' })
            .afterClosed()
            .subscribe(() => this.clearRoute());
          return;
        }
      });
  }

  /**
   * This method is an event from the table that is fired when sort has changed
   * @param sortState
   * @returns
   */
  onSortChange(sortState: Sort | any) {
    if (sortState.direction === 'asc') {
      this.logsService
        .findAll(1)
        .pipe(takeUntil(this.terminator$))
        .subscribe((result) => this.updateTable(result));
      return;
    }
    this.logsService
      .findAll(-1)
      .pipe(takeUntil(this.terminator$))
      .subscribe((result) => this.updateTable(result));
  }

  /**
   * This opens the details dialog by changing the route
   * @param _id
   */
  public openDetailsDialog(id: string) {
    this.router.navigate(['logs'], {
      queryParams: { id: id },
      replaceUrl: true,
    });
  }

  /**
   * This method updates the value in the table
   * @param result the value that will replace the old value
   */
  private updateTable(result: LogModel[]): void {
    this.dataSource.data = result;
    this.dataSource.paginator = this.paginator;
  }

  /**
   * This method replaces all params from the current route
   */
  private clearRoute() {
    this.router.navigate(['/logs'], { replaceUrl: true });
  }
}
