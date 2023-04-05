import { Component, OnDestroy, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { UsersService } from '../users.service';
import { UserCreate } from 'src/app/core/model';
import { Subject, takeUntil } from 'rxjs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-form',
  templateUrl: './form.component.html',
  styleUrls: ['./form.component.scss'],
})
export class FormComponent implements OnInit, OnDestroy {
  private terminator$: Subject<boolean> = new Subject();
  public action: string;

  public form: FormGroup;
  constructor(
    private formBuilder: FormBuilder,
    private usersService: UsersService,
    private route: ActivatedRoute,
    public dialog: MatDialog,
    private _snackBar: MatSnackBar
  ) {}

  /**
   * Calling this method to terminate all subscriptions
   */
  ngOnDestroy(): void {
    this.terminator$.next(true);
    this.terminator$.complete();
  }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      nameControl: new FormControl('', Validators.required),
      loginControl: new FormControl('', Validators.required),
    });

    this.action = this.route.snapshot.queryParams.create ? 'Create' : 'Update';

    if (this.action === 'Update') {
      this.usersService
        .findOne(this.route.snapshot.queryParams.id)
        .pipe(takeUntil(this.terminator$))
        .subscribe((user) => {
          this.form.patchValue({
            nameControl: user.name,
            loginControl: user.login,
          });
        });
    }
  }

  onSubmit() {
    const data: UserCreate = {
      name: this.form.get('nameControl')?.value,
      login: this.form.get('loginControl')?.value,
      timestamp: Number(new Date()),
    };

    if (this.action === 'Create') {
      this.create(data);
      return;
    }
    this.update(data);
  }

  private create(data: UserCreate): void {
    this.usersService
      .create(data)
      .pipe(takeUntil(this.terminator$))
      .subscribe({
        next: () => {
          this._snackBar.open('User created', 'Dismiss');
          this.dialog.closeAll();
        },
        error: (req) => {
          if (
            req.error.message ===
            'This login is already taken! Please, choose another one.'
          ) {
            this.form.controls['loginControl'].setErrors({
              alreadyTaken: req.error.message,
            });
          }
        },
      });
  }

  private update(data: UserCreate): void {
    this.usersService
      .update(data)
      .pipe(takeUntil(this.terminator$))
      .subscribe({
        next: () => {
          this._snackBar.open('User updated', 'Dismiss');
          this.dialog.closeAll();
        },
        error: (req) => {
          if (
            req.error.message ===
            'This login is already taken! Please, choose another one.'
          ) {
            this.form.controls['loginControl'].setErrors({
              alreadyTaken: req.error.message,
            });
          }
        },
      });
  }
}
