import { Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { Sort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { Subject, takeUntil } from 'rxjs';
import { UserModel } from 'src/app/core/model';
import { DetailsComponent } from '../details/details.component';
import { FormComponent } from '../form/form.component';
import { UsersService } from '../users.service';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.scss'],
})
export class ListComponent implements OnInit, OnDestroy {
  @ViewChild(MatPaginator) paginator: MatPaginator;

  public displayedColumns: string[] = ['name', 'timestamp', 'actions'];
  public dataSource: MatTableDataSource<UserModel> = new MatTableDataSource();

  private terminator$: Subject<boolean> = new Subject();

  constructor(
    private usersService: UsersService,
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
    this.usersService
      .findAll()
      .pipe(takeUntil(this.terminator$))
      .subscribe((result) => this.updateTable(result));

    this.route.queryParams
      .pipe(takeUntil(this.terminator$))
      .subscribe((params: Params) => {
        if (params['create']) {
          this.dialog
            .open(FormComponent, { width: 'auto' })
            .afterClosed()
            .subscribe(() => {
              this.usersService
                .findAll(-1)
                .pipe(takeUntil(this.terminator$))
                .subscribe((result) => this.updateTable(result));
              this.clearRoute();
            });
          return;
        }
        if (params['update'] && params['id']) {
          this.dialog
            .open(FormComponent, { width: 'auto' })
            .afterClosed()
            .subscribe(() => {
              this.usersService
                .findAll(-1)
                .pipe(takeUntil(this.terminator$))
                .subscribe((result) => this.updateTable(result));
              this.clearRoute();
            });
          return;
        }
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
      this.usersService
        .findAll(1)
        .pipe(takeUntil(this.terminator$))
        .subscribe((result) => this.updateTable(result));
      return;
    }
    this.usersService
      .findAll(-1)
      .pipe(takeUntil(this.terminator$))
      .subscribe((result) => this.updateTable(result));
  }

  /**
   * This opens the details dialog by changing the route
   * @param _id
   */
  public openDetailsDialog(id: string) {
    this.router.navigate(['users'], {
      queryParams: { id: id },
      replaceUrl: true,
    });
  }

  /**
   * This opens the create dialog by changing the route
   */
  public openCreateDialog() {
    this.router.navigate(['users'], {
      queryParams: { create: true },
      replaceUrl: true,
    });
  }

  /**
   * This opens the update dialog by changing the route
   */
  public openUpdateDialog(id: string) {
    this.router.navigate(['users'], {
      queryParams: { update: true, id },
      replaceUrl: true,
    });
  }

  /**
   * This method updates the value in the table
   * @param result the value that will replace the old value
   */
  private updateTable(result: UserModel[]): void {
    this.dataSource.data = result;
    this.dataSource.paginator = this.paginator;
  }

  /**
   * This method replaces all params from the current route
   */
  private clearRoute() {
    this.router.navigate(['/users'], { replaceUrl: true });
  }
}
