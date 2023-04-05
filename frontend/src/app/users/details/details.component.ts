import { Component, OnDestroy, OnInit } from '@angular/core';
import { UsersService } from '../users.service';
import { ActivatedRoute } from '@angular/router';
import { Subject, takeUntil } from 'rxjs';
import { UserModel } from 'src/app/core/model';

@Component({
  selector: 'app-details',
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.scss'],
})
export class DetailsComponent implements OnInit, OnDestroy {
  private terminator$: Subject<boolean> = new Subject();

  public currentUserId: string;
  public currentUser: UserModel;

  constructor(
    private usersService: UsersService,
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
    this.currentUserId = this.route.snapshot.queryParams['id'];

    this.usersService
      .findOne(this.currentUserId)
      .pipe(takeUntil(this.terminator$))
      .subscribe((user) => {
        this.currentUser = user;
      });
  }
}
